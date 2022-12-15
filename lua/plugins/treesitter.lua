require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "json",
    "html",
    "scss",
    "lua",
    "python",
    "go",
    "latex",
    "tsx",
    "markdown",
    "markdown_inline",
    "vim",
    "query",
    "typescript",
    "javascript",
    "bash",
    "vim",
    "gitignore",
    "svelte",
    "dockerfile",
    "graphql",
  }, -- one of "all", or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "haskell" }, -- list of parsers to ignore installing
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    -- additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "<leader>gnn",
      node_incremental = "<leader>gnr",
      scope_incremental = "<leader>gne",
      node_decremental = "<leader>gnt",
    },
  },

  indent = {
    enable = true,
  },

  autotag = {
    enable = true,
  },

  auto_install = true,

  rainbow = {
    enable = true,
    extended_mode = true,
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    context_commentstring = {
      enable = true,
      config = {
        javascript = {
          __default = "// %s",
          jsx_element = "{/* %s */}",
          jsx_fragment = "{/* %s */}",
          jsx_attribute = "// %s",
          comment = "// %s",
        },
      },
    },
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = "@function.outer",
        ["]m"] = "@class.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
        ["]M"] = "@class.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[m"] = "@class.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[M"] = "@class.outer",
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["~"] = "@parameter.inner",
      },
    },
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ["<cr>"] = "textsubjects-smart", -- works in visual mode
    },
  },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
