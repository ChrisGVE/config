return {
  "doctorfree/cheatsheet.nvim",
  event = "VeryLazy",
  keys = {
    { "_?", "<cmd>Cheatsheet<CR>", desc = "Cheatsheet" },
  },
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  opts = {
    bundled_cheatsheets = {
      enabled = { "default", "lua", "markdown", "regex" },
      disabled = { "nerd-fonts", "netrw", "unicode" },
    },
  },
}
