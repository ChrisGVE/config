return {
  "2kabhishek/nerdy.nvim",
  keys = {
    { "<leader>sn", "<cmd>Nerdy<CR>", desc = "Nerdy" },
    { "<leader>sN", "<cmd>Telescope nerdy<cr>", desc = "Nerdy (telescope)" },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Nerdy",
  config = function()
    require("telescope").load_extension("nerdy")
  end,
}
