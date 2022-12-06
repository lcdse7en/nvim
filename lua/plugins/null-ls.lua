local status, null_ls = pcall(require, "null-ls")
if not status then
  vim.notify "没有找到 null-ls"
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local no_really = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "markdown", "text" },
  generator = {
    fn = function(params)
      local diagnostics = {}
      -- sources have access to a params object
      -- containing info about the current file and editor state
      for i, line in ipairs(params.content) do
        local col, end_col = line:find "really"
        if col and end_col then
          -- null-ls fills in undefined positions
          -- and converts source diagnostics into the required format
          table.insert(diagnostics, {
            row = i,
            col = col,
            end_col = end_col + 1,
            source = "no-really",
            message = "Don't use 'really!'",
            severity = vim.diagnostic.severity.WARN,
          })
        end
      end
      return diagnostics
    end,
  },
}

null_ls.register(no_really)

null_ls.setup {
  debug = false,
  sources = {
    -- formatting.prettier,
    formatting.stylua,
    formatting.autopep8,
    formatting.beautysh,
    --[[ formatting.markdownlint.with {
      filetypes = { "markdown", "md" },
      extra_args = { "--fix", "$FILENAME" },
    },]]
    formatting.prettierd,
    -- diagnostics.eslint_d,
    diagnostics.eslint_d.with { -- js/ts linter
      -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
      condition = function(utils)
        return utils.root_has_file ".eslintrc.js" -- change file extension if you use something else
      end,
    },
    -- Formatting ---------------------
    -- latex
    -- formatting.latexindent,
    formatting.latexindent.with {
      filetypes = { "tex" },
      extra_args = {
        "-s", -- silent
        "-m", -- modifylinegreaks
        "-",
        "-g",
        "/dev/null",
      },
    },
    --  brew install shfmt
    formatting.shfmt,
    -- pip install black
    formatting.black.with {
      filetypes = { "python" },
      extra_args = { "--fast" },
    },
    formatting.prettier.with { -- 比默认少了 markdown
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "yaml",
        "graphql",
        "latex",
        -- "markdown",
        "latex",
        "python",
      },
      prefer_local = "node_modules/.bin",
    },
    -- rustfmt
    -- rustup component add rustfmt
    formatting.rustfmt,
    -- Python
    -- asdf reshim python
    -----------------------------------------------------
    -- Ruby
    -- gem install rubocop
    formatting.rubocop,
    -----------------------------------------------------
    -- formatting.fixjson,
    -- Diagnostics  ---------------------
    diagnostics.eslint.with {
      prefer_local = "node_modules/.bin",
    },
    -- code actions ---------------------
    code_actions.gitsigns,
    code_actions.eslint.with {
      prefer_local = "node_modules/.bin",
    },
  },
  -- #{m}: message
  -- #{s}: source name (defaults to null-ls if not specified)
  -- #{c}: code (if available)
  diagnostics_format = "[#{s}] #{m}",
  on_attach = function(current_client, bufnr)
    if current_client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            filter = function(client)
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          }
        end,
      })
    end
  end,
  -- if client.resolved_capabilities.document_formatting then
  --   vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  -- end
}
