-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local map = vim.keymap.set

local group_id = vim.api.nvim_create_augroup("LuaReloadModule", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group_id,
  pattern = "*.lua",
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    -- Only reload if the first line is local M = {}
    if first_line and first_line:match("^local%s+M%s*=%s*{}") then
      local file_path = vim.fn.expand("%:p")
      local module_name = vim.fn.fnamemodify(file_path, ":.:r")

      package.loaded[module_name] = nil

      vim.notify("Module Reloaded:" .. module_name, nil, {
        title = "Notification",
        timeout = 500,
        render = "compact",
      })
    end
  end,
  desc = "Reload the current module on save",
})

-- LogSitter
group_id = vim.api.nvim_create_augroup("LogSitter", { clear = true })
local logsitter = require("logsitter")
vim.api.nvim_create_autocmd("FileType", {
  group = group_id,
  pattern = "javascript,go,lua",
  callback = function()
    map({ "n", "x" }, "<localleader>l", "", { desc = "Logsitter" })
    map("n", "<localleader>lg", function()
      logsitter.log()
    end, { desc = "log" })

    -- experimental visual mode
    map("x", "<localleader>lg", function()
      logsitter.log_visual()
    end, { desc = "log (experimental)" })
  end,
})

-- Chainsaw
group_id = vim.api.nvim_create_augroup("Chainsaw", { clear = true })
local chainsaw = require("chainsaw")
vim.api.nvim_create_autocmd("FileType", {
  group = group_id,
  pattern = "javascript,go,lua,python,bash,zsh,rust,css",
  callback = function()
    map("n", "<localleader>c", "", { desc = "Chainsaw" })
    map("n", "<localleader>ca", function()
      chainsaw.assertLog()
    end, { desc = "Assert log" })
    map("n", "<localleader>cv", function()
      chainsaw.variableLog()
    end, { desc = "Variable log" })
    map("n", "<localleader>co", function()
      chainsaw.objectLog()
    end, { desc = "Object log" })
    map("n", "<localleader>cT", function()
      chainsaw.typeLog()
    end, { desc = "Type log" })
    map("n", "<localleader>ce", function()
      chainsaw.emojiLog()
    end, { desc = "Emoji log" })
    map("n", "<localleader>cm", function()
      chainsaw.messageLog()
    end, { desc = "Message log" })
    map("n", "<localleader>ct", function()
      chainsaw.timeLog()
    end, { desc = "Time log" })
    map("n", "<localleader>cd", function()
      chainsaw.debugLog()
    end, { desc = "Debug log" })
    map("n", "<localleader>cs", function()
      chainsaw.stacktraceLog()
    end, { desc = "Stacktrace log" })
    map("n", "<localleader>cC", function()
      chainsaw.clearLog()
    end, { desc = "Clear log" })
    map("n", "<localleader>cR", function()
      chainsaw.removeLogs()
    end, { desc = "Remove logs" })
  end,
})
