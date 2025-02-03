return {
  { "present.nvim", dev = true, enabled = false },

  {
    "chrisgve/ai_assistant.nvim", -- placeholder for your custom plugin repo
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      -- Add any additional dependency plugins (e.g., for UI elements)
    },
    keys = {
      -- Map for group description
      { "n", "_a", "", desc = "AI assistance" },
      -- Map _a for generic AI chat command
      {
        "n",
        "_ac",
        function()
          require("ai_assistant").chat()
        end,
        desc = "chat",
      },
      -- Map _ae for code explanation
      {
        "n",
        "_ae",
        function()
          require("ai_assistant").explain()
        end,
        desc = "code explanation",
      },
      -- Map _ad for documentation generation
      {
        "n",
        "_ad",
        function()
          require("ai_assistant").generate_docs()
        end,
        desc = "doc generation",
      },
      -- Map _at for test generation
      {
        "n",
        "_at",
        function()
          require("ai_assistant").generate_tests()
        end,
        desc = "test generation",
      },
      -- Map _ar for refactoring suggestions
      {
        "n",
        "_ar",
        function()
          require("ai_assistant").refactor()
        end,
        desc = "refactoring",
      },
      -- Map _ap for performance improvement suggestions
      {
        "n",
        "_ap",
        function()
          require("ai_assistant").optimize_performance()
        end,
        desc = "code optimization",
      },
    },
    opts = {},
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
