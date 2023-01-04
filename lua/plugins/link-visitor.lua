require("link-visitor").setup {
  open_cmd = nil, --[[ cmd to open url
  defaults:
  win or wsl: cmd.exe /c start
  mac: open
  linux: xdg-open
  ]]
  silent = true, -- disable all prints, `false` by default
}

vim.api.nvim_create_autocmd("User", {
  callback = function()
    local ok, buf = pcall(vim.api.nvim_win_get_buf, vim.g.coc_last_float_win)
    if ok then
      vim.keymap.set("n", "K", function()
        require("link-visitor").link_under_cursor()
      end, { buffer = buf })
      vim.keymap.set("n", "L", function()
        require("link-visitor").link_near_cursor()
      end, { buffer = buf })
    end
  end,
  pattern = "CocOpenFloat",
})
