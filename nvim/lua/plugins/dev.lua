return {
  { "present.nvim", dev = true, enabled = false },
  {
    "chrisgve/taskforge.nvim",
    dependencies = {
      "ahmedkhalf/project.nvim",
      "folke/snacks.nvim", -- optional
      -- "nvimdev/dashboard-nvim", -- optional
    },
    dev = true,
    lazy = false,
    priority = 900,
    opts = { --- configuration for the Dashboard
      dashboard = {
        snacks_options = {
          pane = 2,
          height = 10,
          enable = true,
        },
        format = {
          --- List of columns to be displayed
          columns = {
            "project",
            "description",
            "due",
            "urgency",
          },
        },
        --- List of replacements when getting lines for dashboard
        project_abbreviations = {
          ["neovim."] = "nvim.",
          ["config."] = "cfg.",
          ["python."] = "py.",
          ["fountains."] = "f.",
          ["devtools."] = "dev.",
          ["wezterm."] = "wzt.",
          ["work."] = "wk.",
          ["personal."] = "p.",
        },
      },
    },
  },
}
