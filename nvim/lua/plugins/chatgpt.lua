return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  keys = {
    { "<localleader>c", "", desc = "ChatGPT", mode = { "n", "v" } },
    { "<localleader>cc", "<cmd>ChatGPT<cr>", desc = "ChatGPT", mode = "n" },
    {
      "<localleader>ce",
      "<cmd>ChatGPTEditWithInstruction<cr>",
      desc = "Edit with instructions",
      mode = { "v", "n" },
    },
    {
      "<localleader>cg",
      "<cmd>ChatGPTRun grammar_correction<cr>",
      desc = "Grammar correction",
      mode = { "v", "n" },
    },
    {
      "<localleader>ct",
      "<cmd>ChatGPTRun translate<cr>",
      desc = "Translate",
      mode = { "v", "n" },
    },
    {
      "<localleader>ck",
      "<cmd>ChatGPTRun keywords<cr>",
      desc = "Keywords",
      mode = { "v", "n" },
    },
    {
      "<localleader>cd",
      "<cmd>ChatGPTRun docstring<cr>",
      desc = "Docstring",
      mode = { "v", "n" },
    },
    {
      "<localleader>ca",
      "<cmd>ChatGPTRun add_tests<cr>",
      desc = "Add",
      mode = { "v", "n" },
    },
    {
      "<localleader>co",
      "<cmd>ChatGPTRun optimize_code<cr>",
      desc = "Optimize code",
      mode = { "v", "n" },
    },
    {
      "<localleader>cs",
      "<cmd>ChatGPTRun summarize<cr>",
      desc = "Summarize",
      mode = { "v", "n" },
    },
    {
      "<localleader>cf",
      "<cmd>ChatGPTRun fix_bugs<cr>",
      desc = "Fix bugs",
      mode = { "v", "n" },
    },
    {
      "<localleader>cx",
      "<cmd>ChatGPTRun explain_code<cr>",
      desc = "Explain code",
      mode = { "v", "n" },
    },
    {
      "<localleader>cr",
      "<cmd>ChatGPTRun roxygen_edit<cr>",
      desc = "Roxygen edit",
      mode = { "v", "n" },
    },
    {
      "<localleader>cl",
      "<cmd>ChatGPTRun code_readability_analysis<cr>",
      desc = "Code readability analysis",
      mode = { "v", "n" },
    },
  },
  config = function()
    require("chatgpt").setup({
      -- this config assumes you have OPENAI_API_KEY environment variable set
      openai_params = {
        -- NOTE: model can be a function returning the model name
        -- this is useful if you want to change the model on the fly
        -- using commands
        -- Example:
        -- model = function()
        --     if some_condition() then
        --         return "gpt-4-1106-preview"
        --     else
        --         return "gpt-3.5-turbo"
        --     end
        -- end,
        model = "gpt-3.5-turbo",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim",
  },
}
