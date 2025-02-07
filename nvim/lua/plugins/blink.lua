local prefix = "_a"

return {
  -- avante.nvim
  {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    keys = {
      { prefix, "", desc = "ai" },
    },
    opts = {
      mappings = {
        ask = prefix .. "a",
        edit = prefix .. "e",
        refresh = prefix .. "r",
        focus = prefix .. "f",
        toggle = {
          default = prefix .. "t",
          debug = prefix .. "d",
          hint = prefix .. "h",
          suggestion = prefix .. "s",
          repomap = prefix .. "R",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = prefix .. ".",
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
      provider = "claude",
      openai = {
        model = "gpt-3.5-turbo",
      },
      claude = {
        model = "claude-3-5-sonnet",
      },
      auto_suggestions_provider = "claude",
      dual_boost = {
        enabled = true,
      },
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  -- lsp-config for ctags-lsp.nvim
  {
    "neovim/nvim-lspconfig",
    dependencies = "netmute/ctags-lsp.nvim",
    config = function()
      require("lspconfig").ctags_lsp.setup({})
    end,
  },
  -- minuet-ai.nvim
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "saghen/blink.compat",
      "saghen/blink.cmp",
    },
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
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
          show_on_completion_menu = true,
        },
        blink = {
          enable_auto_complete = true,
        },
        -- Set the default provide to openai
        provider = "openai",
      })
    end,
  },
  -- blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "saghen/blink.compat",
        lazy = true,
        opts = {
          impersonate_nvim_cmp = true,
        },
      },
      "dmitmel/cmp-digraphs",
      "moyiz/blink-emoji.nvim",
      "mikavilpas/blink-ripgrep.nvim",
      "milanglacier/minuet-ai.nvim",
      "Kaiser-Yang/blink-cmp-dictionary",
      "Kaiser-Yang/blink-cmp-git",
    },
    lazy = true,
    opts = {
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "digraphs",
          "git",
          "dictionary",
          "minuet",
          "ripgrep",
          "avante_mentions",
          "avante_files",
          "avante_commands",
          "emoji",
        },
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
          digraphs = {
            module = "blink.compat.source",
            name = "digraphs",
            score_offset = -3,
            opts = {
              cache_digraphs_on_start = true,
            },
          },
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
            -- Only enable dictionary completions for natural language filetypes.
            enabled = function()
              local ft = vim.bo.filetype
              return ft == "markdown" or ft == "text" or ft == "gitcommit"
            end,
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
