local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
  vim.notify "lspsaga not found"
  return
end

saga.init_lsp_saga {
  symbol_in_winbar = require "lspsaga-winbar",
  finder_action_keys = {
    split = "<C-x>",
    tabe = "<C-t>",
    vsplit = "<C-v>",
  },
  definition_action_keys = {
    edit = "e",
    split = "<C-x>",
    vsplit = "<C-v>",
    tabe = "<C-t>",
  },
}
