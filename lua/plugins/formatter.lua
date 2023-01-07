-- Utilities for creating configurations
local util = require "formatter.util"

local prettier = function() -- sudo pacman -S prettier
  return {
    exe = "/usr/bin/prettier",
    args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
    stdin = true,
  }
end

local eslint = function()
  return {
    exe = "eslint",
    args = { "--stdin", "--stdin-filename", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--fix-to-stdout" },
    stdin = true,
  }
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      function()
        return {
          exe = "stylua",
          args = { "--config-path", "~/.config/nvim/.stylua.toml", "-" },
          stdin = true,
        }
      end,
    },

    python = {
      function()
        return {
          exe = "black",
          args = { "--fast", "-", "--color", "--config", "~/.config/black/pyproject.toml" },
          stdin = true,
        }
      end,
    },
    go = {
      function()
        return {
          exe = "gofmt",
          stdin = true,
        }
      end,
    },
    json = { prettier },
    jsonc = { prettier },
    css = { prettier },
    scss = { prettier },
    html = { prettier },
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    vue = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote", "--parser", "vue" },
          stdin = true,
        }
      end,
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      -- require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}
