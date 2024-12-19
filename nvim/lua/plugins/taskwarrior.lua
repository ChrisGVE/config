return {
  "ribelo/taskwarrior.nvim",
  config = true,
  keys = {
    {
      "_t",
      function()
        require("taskwarrior_nvim").browser({ "ready" })
      end,
      desc = "Taskwarrior",
    },
  },
}
