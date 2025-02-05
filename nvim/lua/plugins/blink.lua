return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "netmute/ctags-lsp.nvim",
    config = function()
      require("lspconfig").ctags_lsp.setup({})
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            -- accept whole completion
            accept = "<A-A>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, ot manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
          show_on_completion_menu = true,
        },
        blink = {
          enable_auto_complete = true,
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      "moyiz/blink-emoji.nvim",
      "mikavilpas/blink-ripgrep.nvim",
      "milanglacier/minuet-ai.nvim",
      "Kaiser-Yang/blink-cmp-dictionary",
      "Kaiser-Yang/blink-cmp-git",
    },
    lazy = true,
    opts = {
      sources = {
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
          "emoji",
          "rigrep",
          "minuet",
          "dictionary",
          "git",
        },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            score_offset = 100,
            enabled = true,
            should_show_items = function()
              return vim.o.filteype == "gitcommit" or vim.o.filetype == "markdown"
            end,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
          },
          minuet = {
            module = "minuet.blink",
            name = "minute",
            score_offset = 100,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
          },
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
      completion = { trigger = { prefetch_on_insert = false } }, -- suggested by minuet-ai
    },
  },
}
