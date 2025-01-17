local LazyVim = require("lazyvim")

return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "markdown" },
      root = { "*.md", "*.markdown" },
    })
  end,
  {
    "OXY2DEV/markview.nvim",
    lazy = true, -- false Recommended
    ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" }, -- If you decide to lazy-load anyway
    opts = {
      filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
      buf_ignore = {},
      max_length = 99999,
    },
    keys = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "dhruvasagar/vim-table-mode",
    event = "VeryLazy",
    ft = { "markdown" },
    keys = {
      { "<localleader>t", "", desc = "Table", ft = "markdown" },
      { "<localleader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle table mode", ft = "markdown" },
      { "<localleader>tt", "<cmd>TableModeRealign<cr>", desc = "Realign table", ft = "markdown" },
      { "<localleader>ts", "<cmd>Tableize<cr>", desc = "Tableize", ft = "markdown" },
      { "<localleader>tc", "<cmd>Tableize!<cr>", desc = "Tableize!", ft = "markdown" },
      { "<localleader>td", "<cmd>TableModeDisable<cr>", desc = "Disable table mode", ft = "markdown" },
      { "<localleader>th", "<cmd>TableModeEnable<cr>", desc = "Enable table mode", ft = "markdown" },
      { "<localleader>tn", "<cmd>TableNextRow<cr>", desc = "Next row", ft = "markdown" },
      { "<localleader>tp", "<cmd>TableNextColumn<cr>", desc = "Next column", ft = "markdown" },
      { "<localleader>tN", "<cmd>TablePreviousRow<cr>", desc = "Previous row", ft = "markdown" },
      { "<localleader>tP", "<cmd>TablePreviousColumn<cr>", desc = "Previous column", ft = "markdown" },
    },
    config = function()
      vim.g.table_mode_disable_mappings = 1
    end,
  },
  {
    "vitalk/vim-simple-todo",
    event = "VeryLazy",
    ft = { "markdown" },
    keys = {
      {
        "<localleader>I",
        "<Plug>(simple-todo-new-start-of-line)",
        desc = "New todo (start of line)",
        ft = "markdown",
      },
      { "<localleader>i", "<Plug>(simple-todo-new)", desc = "New todo (cursor)", ft = "markdown" },
      { "<localleader>o", "<Plug>(simple-todo-below)", desc = "New todo (below)", ft = "markdown" },
      { "<localleader>O", "<Plug>(simple-todo-above)", desc = "New todo (above)", ft = "markdown" },
      { "<localleader>s", "<Plug>(simple-todo-mark-switch)", desc = "Switch todo", ft = "markdown" },
      { "<localleader>x", "<Plug>(simple-todo-mark-as-done)", desc = "Mark done", ft = "markdown" },
      { "<localleader>X", "<Plug>(simple-todo-mark-as-undone)", desc = "Mark undone", ft = "markdown" },
      { "<localleader>-", "<Plug>(simple-todo-new-list-item)", desc = "New item in list", ft = "markdown" },
      {
        "<localleader>_",
        "<Plug>(simple-todo-new-list-item-start-of-line)",
        desc = "New item in list (start of line)",
        ft = "markdown",
      },
    },
  },
}
