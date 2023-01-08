-- Requires
local ok, lspkind = pcall(require, "lspkind")
if not ok then
  return
end

local cmp_tabnine_status_ok, tabnine = pcall(require, "cmp_tabnine.config")
if not cmp_tabnine_status_ok then
  return
end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_snipmate").lazy_load { paths = { "./snippets" } }
require("luasnip/loaders/from_vscode").load {
  paths = { "~/.config/nvim/other/friendly-snippets" },
}

-- Utils
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

-- Setup
local source_mapping = {
  npm = EcoVim.icons.terminal .. "NPM",
  cmp_tabnine = EcoVim.icons.light,
  nvim_lsp = EcoVim.icons.paragraph .. "LSP",
  buffer = EcoVim.icons.buffer .. "BUF",
  nvim_lua = EcoVim.icons.bomb,
  luasnip = EcoVim.icons.snippet .. "SNP",
  calc = EcoVim.icons.calculator,
  path = EcoVim.icons.folderOpen2,
  treesitter = EcoVim.icons.tree,
  zsh = EcoVim.icons.terminal .. "ZSH",
  look = EcoVim.icons.paragraph .. "LOOK",
}

local buffer_option = {
  -- Complete from all visible buffers (splits)
  get_bufnrs = function()
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    return vim.tbl_keys(bufs)
  end,
}

cmp.setup {
  preselect = cmp.PreselectMode.Item,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-2), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(2), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    --["<CR>"] = cmp.mapping.confirm { select = EcoVim.plugins.completion.select_first_on_enter },
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.symbolic(vim_item.kind, { with_text = true })
      local menu = source_mapping[entry.source.name]
      local maxwidth = 50

      if entry.source.name == "cmp_tabnine" then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = menu .. entry.completion_item.data.detail
        else
          menu = menu .. "TBN"
        end
      end

      vim_item.menu = menu
      vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)

      return vim_item
    end,
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = "nvim_lsp", priority = 9 },
    { name = "npm", priority = 9 },
    { name = "cmp_tabnine", priority = 8, max_num_results = 3 },
    { name = "luasnip", priority = 7, max_item_count = 8 },
    { name = "buffer", priority = 7, keyword_length = 5, option = buffer_option, max_item_count = 8 },
    { name = "nvim_lua", priority = 5 },
    { name = "path", priority = 99 },
    { name = "emoji", priority = 50 },
    { name = "calc", priority = 3 },
    { name = "vsnip" },
    {
      name = "look",
      priority = 9,
      keyword_length = 2,
      option = {
        convert_case = true,
        loud = true,
        dict = "/home/se7en/.local/share/dict/words",
      },
    },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    },
  },

  sorting = {
    comparators = {
      cmp.config.compare.exact,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    },
  },

  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },

  window = {
    completion = cmp.config.window.bordered {
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
    documentation = cmp.config.window.bordered {
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
  },

  experimental = {
    ghost_text = true,
  },
}

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

tabnine:setup {
  max_lines = 1000,
  max_num_results = 3,
  sort = true,
  show_prediction_strength = true,
  run_on_every_keystroke = true,
  snipper_placeholder = "..",
  ignored_file_types = {},
}

-- cmp.setup.filetype({ "TelescopePrompt" }, {
--   sources = {},
-- })
-- cmp.setup.filetype({ "vim", "markdown", "tex" }, {
--   sources = {
--     {
--       name = "look",
--       keyword_length = 5,
--       max_item_count = 5,
--       option = {
--         convert_case = true,
--         loud = true,
--         dict = "/home/se7en/.local/share/dict/words",
--       },
--     },
--   },
-- })
