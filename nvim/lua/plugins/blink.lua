-- lua/plugins/blink.lua
local function get_ai_config()
  if vim.env.ANTHROPIC_API_KEY then
    return {
      provider = "anthropic",
      model = {
        name = "claude-3-sonnet-20240229",
        api_key = vim.env.ANTHROPIC_API_KEY,
      },
    }
  else
    return {
      provider = "openai",
      model = {
        name = "gpt-3.5-turbo-0125",
        api_key = vim.env.OPENAI_API_KEY,
      },
    }
  end
end

return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "tzachar/cmp-ai",
    },
    opts = {
      sources = {
        default = { "buffer", "path", "lazydev", "ai" },
        providers = {
          buffer = {
            name = "buffer",
            module = "blink.cmp.sources.buffer",
          },
          path = {
            name = "path",
            module = "blink.cmp.sources.path",
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          ai = {
            name = "cmp_ai",
            module = "cmp_ai.source",
            score_offset = 85,
            opts = {
              max_lines = 100,
              temperature = 0.1,
              top_p = 0.95,
              stop_pattern = "[;{}]",
              notify = true,
              async = true,
              context = {
                window = 5, -- Lines before cursor
                file = true, -- Include current file context
              },
              -- Merge in provider-specific config
              unpack(get_ai_config()),
            },
          },
        },
      },
    },
  },
}
