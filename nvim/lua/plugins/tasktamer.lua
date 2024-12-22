if vim.uv.fs_stat("~/dev/projects/plugins/tasktamer.nvim/lazy.lua") then
  return {
    "tasktamer.nvim",
    dev = true,
    opts = {},
  }
else
  return {}
end
