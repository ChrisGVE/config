local tm = nil

local isInstalled = pcall(require, "tasktamer")

if isInstalled then
  tm = require("tasktamer")
end
-- local ltw = require("little-taskwarrior")

if tm ~= nil then
  return {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "figlet -f ~/.config/figlet_custom/ansi_shadow 'LAZYVIM' | lolcat -F 0.3 -t -p 100 -f",
            height = 6,
            padding = 1,
            align = "center",
          },
          {
            icon = "",
            title = "Tasks",
            pane = 2,
          },
          {
            text = tm.get_snacks_dashboard_tasks(56, "dir", "special"),
            pane = 2,
            indent = 3,
            height = 10,
          },
          { icon = " ", title = "Keymaps", section = "keys", indent = 3, gap = 1, padding = 1, pane = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 3, padding = 1 },
          {

            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            -- enabled = function()
            --   print(Snacks.git.get_root())
            --   local obj = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait()
            --   return obj.code == 0
            -- end,
            cmd = "hub status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup", pane = 2 },
        },
      },
    },
  }
else
  return {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          {
            section = "terminal",
            cmd = "figlet -f ~/.config/figlet_custom/ansi_shadow 'LAZYVIM' | lolcat -F 0.3 -t -p 100 -f",
            height = 6,
            padding = 1,
            align = "center",
          },
          -- {
          --   icon = "",
          --   title = "Tasks",
          --   pane = 2,
          -- },
          -- {
          --   text = tm.get_snacks_dashboard_tasks(56, "dir", "special"),
          --   pane = 2,
          --   indent = 3,
          --   height = 10,
          -- },
          { icon = " ", title = "Keymaps", section = "keys", indent = 3, gap = 1, padding = 1, pane = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 3, padding = 1 },
          {

            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            -- enabled = function()
            --   print(Snacks.git.get_root())
            --   local obj = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait()
            --   return obj.code == 0
            -- end,
            cmd = "hub status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup", pane = 2 },
        },
      },
    },
  }
end
