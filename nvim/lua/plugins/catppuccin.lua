return {
  "catppuccin/nvim",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      dim_inactive = {
        enabled = true,
        percentage = 0.5,
      },
      styles = {
        numbers = { "italic" },
      },
    })
  end,
}
