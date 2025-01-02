return {
  "philosofonusus/ecolog.nvim",
  keys = {
    { "_e", "", desc = "Ecolog" },
    { "_ee", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "_ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
    { "_es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    { "_er", "<cmd>ECologRefresh<cr>", desc = "Refresh env variable cache" },
  },
  load_shell = {
    enabled = true,
    override = false, -- .env files take precedence over shell variables
    filter = function(key, value)
      return key:match("^(PATH|HOME|USER|XDG)$") ~= nil
    end,
    transform = function(key, value)
      return "[shell] " .. value
    end,
  },
  -- Lazy loading is done internally
  lazy = false,
  opts = {
    integrations = {
      -- WARNING: for both cmp integrations see readme section below
      nvim_cmp = false, -- If you dont plan to use nvim_cmp set to false, enabled by default
      -- If you are planning to use blink cmp uncomment this line
      blink_cmp = true,
    },
    -- Enables shelter mode for sensitive values
    shelter = {
      configuration = {
        partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
        mask_char = "*", -- Character used for masking
      },
      modules = {
        cmp = true, -- Mask values in completion
        peek = false, -- Mask values in peek view
        files = false, -- Mask values in files
        telescope = false, -- Mask values in telescope
        fzf = false, -- Mask values in fzf picker
      },
    },
    -- true by default, enables built-in types (database_url, url, etc.)
    types = true,
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = "development", -- Optional: prioritize specific env files
  },
}
