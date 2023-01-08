local status_ok, spell = pcall(require, "spell")
if not status_ok then
  vim.notify("spell not found!")
end

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
