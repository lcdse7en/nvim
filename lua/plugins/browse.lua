local status_ok, browse = pcall(require, "browse")
if not status_ok then
  return
end

browse.setup {
  provider = "brave",
}

local bookmarks = {
  --"https://github.com/rockerBOO/awesome-neovim",
  "https://github.com/lcdse7en",
  "https://wangchujiang.com/linux-command/",
  "https://github.com/ecosse3/nvim",
  "https://github.com/LukeSmithxyz/voidrice/tree/master/.config",
  "https://torrentgalaxy.to/",
  "https://www.colorhexa.com/color-names",
  "https://texdoc.org/index.html",
  "https://github.com/Allaman/nvim",
  "https://github.com/christianchiarulli",
  --"https://github.com/theniceboy",
  --"https://github.com/andreqls",
  --"https://aur.archlinux.org/packages/",
  --"https://suckless.org/",
  "https://m.weibo.cn/u/1965284462",
  "http://kkhanju.top/",
  "https://www.kpopn.com/category/news",
  "https://www.extfans.com/",
  "https://unicode.org/emoji/charts/full-emoji-list.html",
  --"https://github.com/davatorium/rofi-themes",
  -- "https://github.com/glepnir",
}

local function command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

command("BrowseInputSearch", function()
  browse.input_search()
end, {})

command("Browse", function()
  browse.browse { bookmarks = bookmarks }
end, {})

command("BrowseBookmarks", function()
  browse.open_bookmarks { bookmarks = bookmarks }
end, {})

command("BrowseDevdocsSearch", function()
  browse.devdocs.search()
end, {})

command("BrowseDevdocsFiletypeSearch", function()
  browse.devdocs.search_with_filetype()
end, {})

command("BrowseMdnSearch", function()
  browse.mdn.search()
end, {})

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("n", "<m-o>", "<cmd>BrowseBookmarks<cr>", opts)
keymap("n", "<m-i>", "<cmd>BrowseInputSearch<cr>", opts)
