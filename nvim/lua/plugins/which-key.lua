return {
  "folke/which-key.nvim",
  keys = {
    -- lua section
    { "<localleader>X", "<cmd>source %<cr>", mode = "n", ft = "lua", desc = "Execute file" },
    { "<localleader>x", ":.lua<cr>", mode = "n", ft = "lua", desc = "Execute line" },
    { "<localleader>x", ":lua<cr>", mode = "v", ft = "lua", desc = "Execute selection" },
    { "<leader>tp", "<cmd>PlenaryBustedFile<cr>", mode = "n", ft = "lua", desc = "Plenary busted file" },
    { "<leader>tP", "<cmd>PlenaryBustedDirectory<cr>", mode = "n", ft = "lua", desc = "Plenary busted directory" },
  },
}
