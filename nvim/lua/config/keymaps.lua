-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Insert new line
map("n", "<cr>", "o<Esc>", { desc = "Insert blank line below" })
map("n", "<S-cr>", "O<Esc>", { desc = "Insert blank line above" })

-- Visual mode moving blocks
-- map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move block down" })
-- map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move block up" })

-- Navigation putting the cursor in the middle of the screen
-- map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
-- map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
-- map("n", "<c-f>", "<c-f>zz", { desc = "page down" })
-- map("n", "<c-b>", "<c-b>zz", { desc = "page up" })
-- map("n", "k", "kzz", { desc = "Down" })
-- map("n", "j", "jzz", { desc = "Up" })
-- map("n", "n", "nzzzv", { desc = "Next search result" })
-- map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Deactivate notification from <leader>n too (already exists under ui)
-- map("n", "<leader>nn", function()
--   Snacks.notifier.hide()
-- end, { desc = "Dismiss All Notification" })

-- Smart-splits keymaps
--
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
map("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize left window" })
map("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Reside down window" })
map("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize up window" })
map("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize right window" })

-- moving between splits
map("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move left window" })
map("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move down window" })
map("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move up window" })
map("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move right window" })
map("n", "<C-\\>", require("smart-splits").move_cursor_previous, { desc = "Move to previous window" })

-- swapping buffers between windows
map("n", "<leader><Left>", require("smart-splits").swap_buf_left, { desc = "Swap buffer left window" })
map("n", "<leader><Down>", require("smart-splits").swap_buf_down, { desc = "Swap buffer down window" })
map("n", "<leader><Up>", require("smart-splits").swap_buf_up, { desc = "Swap buffer up window" })
map("n", "<leader><Right>", require("smart-splits").swap_buf_right, { desc = "Swap buffer right window" })

-- mapping for Neogit
--
-- local neogit = require("neogit")
-- local ng_prefix = "_g"
-- local neogit_cmds = {
--   bisect = { key = "B", desc = "bisect" },
--   branch = { key = "b", desc = "branch" },
--   branch_config = { key = "F", desc = "branch config" },
--   cherry_pick = { key = "C", desc = "cherry_pick" },
--   commit = { key = "c", desc = "commit" },
--   diff = { key = "d", desc = "diff" },
--   fetch = { key = "f", desc = "fetch" },
--   help = { key = "h", desc = "help" },
--   ignore = { key = "i", desc = "ignore" },
--   log = { key = "l", desc = "log" },
--   merge = { key = "m", desc = "merge" },
--   pull = { key = "p", desc = "pull" },
--   push = { key = "P", desc = "push" },
--   rebase = { key = "r", desc = "rebase" },
--   remote = { key = "R", desc = "remote" },
--   remote_config = { key = "T", desc = "remote config" },
--   reset = { key = "E", desc = "reset" },
--   revert = { key = "v", desc = "revert" },
--   stash = { key = "s", desc = "stash" },
--   tag = { key = "t", desc = "tag" },
--   worktree = { key = "w", desc = "worktree" },
-- }
-- map("n", ng_prefix, "", { desc = "Neogit" })
-- for key, value in pairs(neogit_cmds) do
--   map("n", ng_prefix .. value.key, "<cmd>Neogit " .. key .. "<cr>", { desc = value.desc })
-- end
