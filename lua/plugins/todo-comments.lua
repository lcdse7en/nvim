local status_ok, todo_comments = pcall(require, "todo-comments")
if not status_ok then
  return
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup                                                    │
-- ╰──────────────────────────────────────────────────────────╯
todo_comments.setup {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    -- alt ： 别名
    FIX = {
      icon = " ",
      color = "#DC2626",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "!" },
    },
    TODO = { icon = " ", color = "#2563EB" },
    HACK = { icon = " ", color = "#7C3AED" },
    WARN = { icon = " ", color = "#FBBF24", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", color = "#FC9868", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "#10B981", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
}
-- ╭──────────────────────────────────────────────────────────╮
-- │  Keymappings                                             │
-- ╰──────────────────────────────────────────────────────────╯

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
