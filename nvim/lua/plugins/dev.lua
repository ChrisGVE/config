return {
  { "present.nvim", dev = true, enabled = false },

  {
    "chrisgve/ai_assistant.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "_a", desc = "AI assistance" },
      {
        "_ac",
        function()
          require("ai_assistant").handle_command("chat")
        end,
        desc = "chat",
      },
      {
        "_ae",
        function()
          require("ai_assistant").handle_command("explain")
        end,
        desc = "explain",
      },
      {
        "_ad",
        function()
          require("ai_assistant").handle_command("docs")
        end,
        desc = "docs",
      },
      {
        "_at",
        function()
          require("ai_assistant").handle_command("test")
        end,
        desc = "test",
      },
      {
        "_ar",
        function()
          require("ai_assistant").handle_command("refactor")
        end,
        desc = "refactor",
      },
      {
        "_ap",
        function()
          require("ai_assistant").handle_command("optimize")
        end,
        desc = "optimize",
      },
    },
    opts = {
      debug = {
        enabled = true,
        log_file = "/Users/chris/dev/projects/plugins/ai_assistant.nvim/debug.log",
      },
      providers = {
        { name = "copilot", priority = 1 },
        { name = "ollama", priority = 2, endpoint = "http://localhost:11434", model = "codellama" },
        { name = "claude", priority = 3 },
        { name = "openai", priority = 4 },
      },
    },
  },

  {
    "chrisgve/taskforge.nvim",
    dependencies = {
      "ahmedkhalf/project.nvim",
      "folke/snacks.nvim", -- optional
      -- "nvimdev/dashboard-nvim", -- optional
    },
    dev = true,
    lazy = false,
    priority = 900,
    opts = { --- configuration for the Dashboard
      debug = {
        --- toggle the logging
        debug = true,
        log_file = "/Users/chris/dev/projects/plugins/taskforge.nvim/debug.log",
        log_max_len = 160,
      },
      project = {
        project_synonyms = {
          ["config"] = ".config",
          ["keyboard"] = { "qmk_userspace", "qmk_firmware", "qmk_keychron" },
        },
      },
      dashboard = {
        snacks_options = {
          pane = 2,
          height = 5,
          enable = true,
        },
        format = {
          --- List of columns to be displayed
          columns = {
            "project",
            "description",
            -- "due",
            "urgency",
          },
        },
        --- List of replacements when getting lines for dashboard
        project_abbreviations = {
          ["neovim."] = "nvim.",
          ["config."] = "cfg.",
          ["python."] = "py.",
          ["fountains."] = "f.",
          ["devtools."] = "dev.",
          ["wezterm."] = "wzt.",
          ["work."] = "wk.",
          ["personal."] = "p.",
        },
      },
    },
  },
}
