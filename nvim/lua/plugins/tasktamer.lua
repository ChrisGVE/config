if vim.fn.isdirectory("~/dev/projects/plugins/tasktamer.nvim") then
  return {
    "tasktamer.nvim",
    dev = true,
    opts = {},
  }
else
  return {}
end
