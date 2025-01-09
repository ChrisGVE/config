return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOps
  opts = {
    watch_for_changes = true,
  },
  event = "VeryLazy",
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
    { "nvim-tree/nvim-web-devicons" },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
