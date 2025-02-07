-- blink.lua
--
-- This file sets up minuet-ai.nvim with blink.cmp, avante.nvim, and a custom local model source using Ollama.
--
-- Local Model (Ollama) Setup Instructions:
-- 1. Install Ollama from https://ollama.com/ and ensure it's running.
-- 2. Install and enable your desired local model in Ollama.
-- 3. This configuration assumes an API endpoint at "http://localhost:11434/api/completion".
--    Adjust this endpoint if your Ollama installation uses a different port or path.
-- 4. The payload below sends { model = "your-ollama-model", prompt = "...", max_tokens = 100 }.
--    Replace "your-ollama-model" with your actual Ollama model identifier.
--    If you want coding completions, be sure to use a model that’s trained for code.
--
-- API keys for OpenAI and Anthropic (Claude) are read from the environment variables:
--   OPENAI_API_KEY and ANTHROPIC_API_KEY.
--
-- This configuration is optimized for your most-used languages: Lua, Python, Zig, C/C++, shell scripting, SQL,
-- with occasional Rust and Swift editing, plus frequent Markdown files.
--
-----------------------------------------------------------------------
-- Define the custom module for the local model source using Ollama.
-----------------------------------------------------------------------
local local_model = {}

---[[
-- The `complete` method is called by blink.cmp with a table `params`
-- (which contains at least a context with the current prefix) and a callback.
-- This implementation uses Plenary's Job to call a local HTTP server via curl.
-- The local server should accept a JSON payload like:
--   { model = "your-ollama-model", prompt = "...", max_tokens = 100 }
-- and return a JSON response with a field "suggestions" that is an array of suggestion strings.
---]]
function local_model:complete(params, callback)
  local Job = require("plenary.job")
  local prompt = ""
  if params.context and params.context.prefix then
    prompt = params.context.prefix
  end
  local payload = {
    model = "deepseek-r1:1.5b", -- Replace with your Ollama model name if needed
    prompt = prompt,
    max_tokens = 100,
  }
  local json_payload = vim.fn.json_encode(payload)
  Job:new({
    command = "curl",
    args = {
      "-s",
      "-X",
      "POST",
      "-H",
      "Content-Type: application/json",
      "-d",
      json_payload,
      "http://localhost:11434/api/completion",
    },
    on_exit = function(j, _)
      local result = table.concat(j:result(), "\n")
      local ok, parsed = pcall(vim.fn.json_decode, result)
      if not ok then
        vim.notify("Ollama local model completion: error parsing JSON: " .. result, vim.log.levels.ERROR)
        callback({})
        return
      end
      local completions = {}
      for _, suggestion in ipairs(parsed.suggestions or {}) do
        table.insert(completions, {
          label = suggestion,
          insertText = suggestion,
          detail = "Ollama Local",
        })
      end
      callback(completions)
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify("Ollama local model completion error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
  }):start()
end

-- Add a "new" constructor so that blink.cmp can instantiate the source.
function local_model.new()
  return local_model
end

package.loaded["blink_local_model"] = local_model

-----------------------------------------------------------------------
-- Plugin configuration table
-----------------------------------------------------------------------
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "netmute/ctags-lsp.nvim",
    config = function()
      require("lspconfig").ctags_lsp.setup({})
    end,
  },
  {
    "yetone/avante.nvim",
    enabled = true, -- leaving it enabled per your request
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    keys = {
      { "_a", "", desc = "ai" },
    },
    opts = {
      mappings = {
        ask = "_aa",
        edit = "_ae",
        refresh = "_ar",
        focus = "_af",
        toggle = {
          default = "_at",
          debug = "_ad",
          hint = "_ah",
          suggestion = "_as",
          repomap = "_aR",
        },
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = "_.",
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
      provider = "claude",
      openai = {
        model = "gpt-3.5-turbo",
        api_key = os.getenv("OPENAI_API_KEY") or "",
      },
      claude = {
        model = "claude-3-5-sonnet",
        api_key = os.getenv("ANTHROPIC_API_KEY") or "",
      },
      auto_suggestions_provider = "claude",
      dual_boost = {
        enabled = true,
      },
      file_selector = {
        provider = "snacks",
      },
    },
    build = "make", -- build from source if needed
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true, -- required for Windows users
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
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
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
          show_on_completion_menu = true,
        },
        blink = {
          enable_auto_complete = true,
        },
        -- Set the default provider to "openai" to avoid Codestral and to obtain coding completions.
        provider = "openai",
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
          "local_model", -- our custom Ollama local model source
        },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            score_offset = 100,
            enabled = true,
            should_show_items = function()
              return vim.o.filetype == "gitcommit" or vim.o.filetype == "markdown"
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
            name = "minuet",
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
            score_offset = 90, -- higher priority than LSP suggestions
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 100, -- slightly higher priority
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- highest priority among avante sources
            opts = {},
          },
          local_model = {
            module = "blink_local_model",
            name = "Local",
            score_offset = 50, -- adjust this offset as needed
          },
        },
      },
      completion = { trigger = { prefetch_on_insert = false } },
    },
  },
}
