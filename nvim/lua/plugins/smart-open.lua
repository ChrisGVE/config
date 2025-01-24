return {
  enabled = false,
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  config = function()
    require("telescope").load_extension("smart_open")
    require("telescope").setup({
      extensions = {
        smart_open = {
          match_algorithm = "fzf",
          show_scores = true,
        },
      },
    })
  end,
  dependencies = {
    "kkharji/sqlite.lua",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope").extensions.smart_open.smart_open()
      end,
      desc = "Smart open",
    },
  },
}
