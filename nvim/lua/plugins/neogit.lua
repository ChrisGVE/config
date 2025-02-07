-- if vim.fn.executable("lazygit") == 1 then
--   return {}
-- else
--   return {
--     "NeogitOrg/neogit",
--     dependencies = {
--       "nvim-lua/plenary.nvim", -- required
--       "sindrets/diffview.nvim", -- optional - Diff integration
--
--       -- Only one of these is needed.
--       "nvim-telescope/telescope.nvim", -- optional
--       "ibhagwan/fzf-lua", -- optional
--       "echasnovski/mini.pick", -- optional
--     },
--     config = true,
--   }
-- end

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    -- "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua", -- optional
    -- "echasnovski/mini.pick", -- optional
  },
  config = true,
}
