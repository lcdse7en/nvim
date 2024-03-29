-- Setup installer & lsp configs
local typescript_ok, typescript = pcall(require, "typescript")
local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
local ufo_config = require "plugins.nvim-ufo"

if not mason_ok or not mason_lsp_ok then
  return
end

--[[ local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end ]]

mason.setup {
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = EcoVim.ui.float.border or "rounded",
  },
}

mason_lsp.setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "bashls",
    "cssls",
    "eslint",
    "graphql",
    "html",
    "jsonls",
    "sumneko_lua",
    "tailwindcss",
    "tsserver",
    "yamlls",
    "vuels",
    "volar",
    "prismals",
    "gopls", --  NOTE: export GOPROXY=https://proxy.golang.com.cn,direct
    "pyright",
    -- "ltex",
    "texlab",
    "marksman",
  },

  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  automatic_installation = true,
}

--[[ mason_null_ls.setup {
  ensure_installed = {
    "prettier",
    "stylua",
    "eslint_d",
    "luaformatter",
    "autopep8",
    "black",
    "shfmt",
    "beautysh",
    "markdownlint",
    "prettierd",
  },
} ]]

local lspconfig = require "lspconfig"

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = EcoVim.ui.float.border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = EcoVim.ui.float.border }),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = EcoVim.lsp.virtual_text }
  ),
}

local keymap = vim.keymap
local function on_attach(client, bufnr)
  -- set up buffer keymaps, etc.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", opts)
  keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<cr>", opts)
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>", opts)
  keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)
  keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
  keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_cursor_diagnostics<cr>", opts)
  keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<cr>", opts)
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)

  if client.name == "tsserver" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<cr>")
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Order matters

-- It enables tsserver automatically so no need to call lspconfig.tsserver.setup
if typescript_ok then
  typescript.setup {
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    -- LSP Config options
    server = {
      capabilities = require("lsp.servers.tsserver").capabilities,
      handlers = require("lsp.servers.tsserver").handlers,
      on_attach = require("lsp.servers.tsserver").on_attach,
      settings = require("lsp.servers.tsserver").settings,
    },
  }
end

lspconfig.tailwindcss.setup {
  capabilities = require("lsp.servers.tailwindcss").capabilities,
  filetypes = require("lsp.servers.tailwindcss").filetypes,
  handlers = handlers,
  init_options = require("lsp.servers.tailwindcss").init_options,
  on_attach = require("lsp.servers.tailwindcss").on_attach,
  settings = require("lsp.servers.tailwindcss").settings,
}

lspconfig.cssls.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = require("lsp.servers.cssls").on_attach,
  settings = require("lsp.servers.cssls").settings,
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = require("lsp.servers.eslint").on_attach,
  settings = require("lsp.servers.eslint").settings,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require("lsp.servers.jsonls").settings,
}

lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  -- settings = require("lsp.servers.sumneko_lua").settings,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
}

lspconfig.vuels.setup {
  filetypes = require("lsp.servers.vuels").filetypes,
  handlers = handlers,
  init_options = require("lsp.servers.vuels").init_options,
  on_attach = on_attach,
}

lspconfig.pyright.setup {
  filetypes = require("lsp.servers.pyright").filetypes,
  handlers = handlers,
  init_options = require("lsp.servers.pyright").init_options,
  on_attach = on_attach,
}
lspconfig.texlab.setup {
  filetypes = require("lsp.servers.tex").filetypes,
  handlers = handlers,
  init_options = require("lsp.servers.tex").init_options,
  on_attach = on_attach,
}
lspconfig.gopls.setup {
  filetypes = require("lsp.servers.gopls").filetypes,
  handlers = handlers,
  init_options = require("lsp.servers.gopls").init_options,
  on_attach = on_attach,
}

for _, server in ipairs {
  "bashls",
  "emmet_ls",
  "graphql",
  "html",
  "volar",
  "prismals",
  "pyright",
  "sumneko_lua",
  "gopls",
  "texlab",
  "marksman",
  "jsonls",
} do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
  }
end

require("ufo").setup {
  fold_virt_text_handler = ufo_config.handler,
  close_fold_kinds = { "imports" },
}
