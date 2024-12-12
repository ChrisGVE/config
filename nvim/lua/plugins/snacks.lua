Snacks = require("snacks")
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
    dashboard = {
      preset = {
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      sections = {
        { section = "header" },
        { pane = 2, height = 5, padding = 1 },
        { icon = " ", title = "Keymaps", section = "keys", indent = 3, gap = 1, padding = 1 },
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
        { section = "startup" },
      },
    },
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
