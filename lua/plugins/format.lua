local status, formatter = pcall(require, "formatter")
if not status then
  vim.notify "not fond formatter plugin"
  return
end

formatter.setup {
  filetype = {
    lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "-f $HOME/.config/nvim/.stylua.toml",
            "-",
          },
          stdin = true,
        }
      end,
    },
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
          stdin = true,
        }
      end,
    },
    json = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--double-quote" },
          stdin = true,
        }
      end,
    },
    python = {
      -- Configuration for psf/black
      --[[ function()
        return {
          -- exe = "python3 -m autopep8", -- this should be available on your $PATH
          exe = "autopep8", -- this should be available on your $PATH
          args = {
            "--in-place --aggressive --aggressive",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
        }
      end, ]]
    },
    go = {
      function()
        return {
          exe = "goimports",
          args = {
            "-w",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
        }
      end,
    },
  },
}
