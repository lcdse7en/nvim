require("org-bullets").setup {
    concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
    symbols = {
      -- headlines can be a list
      headlines = { "◉", "○", "✸", "✿" },
      -- or a function that receives the defaults and returns a list
      headlines = function(default_list)
        table.insert(default_list, "♥")
        return default_list
      end,
      checkboxes = {
        half = { "", "OrgTSCheckboxHalfChecked" },
        done = { "✓", "OrgDone" },
        todo = { "˟", "OrgTODO" },
      },
    }
  }
