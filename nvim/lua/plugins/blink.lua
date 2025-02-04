return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      "moyiz/blink-emoji.nvim",
    },
    lazy = true,
    opts = {
      sources = {
        compat = { "avante_commands", "avante_mentions", "avante_files", "emoji" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
          },
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90, -- show at a higher priority than lsp
            opts = {},
          },
          avante_files = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 100, -- show at a higher priority than lsp
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- show at a higher priority than lsp
            opts = {},
          },
        },
      },
    },
  },
}
