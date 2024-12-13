return {
  "duckdm/neowarrior.nvim",
  opts = {},
  keys = {
    { "<localleader>n", "", desc = "NeoWarrior" },
    { "<localleader>no", "<cmd>NeoWarriorOpen<cr>", desc = "Open NeoWarrior" },
    { "<localleader>na", "<cmd>NeoWarriorAdd<cr>", desc = "Add a task" },
    { "<localleader>nf", "<cmd>NeoWarriorFilter<cr>", desc = "Filter" },
    { "<localleader>ns", "<cmd>NeoWarriorFilterSelect<cr>", desc = "Select filter" },
    { "<localleader>nr", "<cmd>NeoWarriorReport<cr>", desc = "Select report" },
    { "<localleader>nR", "<cmd>NeoWarriorRefresh<cr>", desc = "Refresh tasks" },
  },
}
