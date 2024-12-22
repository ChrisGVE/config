local Snacks = require("snacks")
vim.ui.input = Snacks.input

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    zen = {},
    dim = {},
    indent = {},
    input = {},
    scope = {},
    scroll = {},
    animate = {},
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    statuscolumn = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    { "<leader>n", "", desc = "notifications" },
    { "<leader>nh", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = "history" },
    {
      "<leader>nN",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
