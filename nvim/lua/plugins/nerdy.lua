return {
  "2kabhishek/nerdy.nvim",
  keys = {
    { "<leader>sN", "<cmd>Nerdy<CR>", desc = "Nerdy" },
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
