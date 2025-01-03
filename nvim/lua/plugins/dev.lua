return {
  -- { dir = "~/dev/projects/plugins/present.nvim" },
  { "present.nvim", dev = true, enabled = false },
  {
    "chrisgve/tasktamer.nvim",
    dev = true,
    config = function()
      require("tasktamer").setup({ --- configuration for the Dashboard
        dashboard = {
          --- List of columns to be displayed
          columns = {
            "project",
            "description",
            "due",
            "urgency",
          },
          --- List of replacements when getting lines for dashboard
          project_replacements = {
            ["neovim."] = "nvim.",
            ["config."] = "cfg.",
            ["python."] = "py.",
            ["fountains."] = "f.",
            ["devtools."] = "dev.",
            ["wezterm."] = "wzt.",
            ["work."] = "wk.",
            ["personal."] = "pers.",
          },
        },
      })
    end,
  },
}
