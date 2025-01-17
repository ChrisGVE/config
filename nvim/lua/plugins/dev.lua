return {
  { dir = "~/dev/projects/plugins/present.nvim" },
  { "present.nvim", dev = true, enabled = false },
  {
    "chrisgve/taskforge.nvim",
    dev = true,
    config = function()
      require("taskforge").setup({ --- configuration for the Dashboard
        dashboard = {
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
      })
    end,
  },
}
