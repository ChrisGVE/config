-- Formatting options
--
-- log types
--  variableLog
--  objectLog
--  typeLog
--  assertLog
--  emojiLog (for quick control flow)
--  messageLog
--  timeLog (1st call: start, 2nd call: time duration since first call)
--  debugLog (similar to a breakpoint())
--  stacktraceLog
--  clearLog (clearing statement such as console.clear())
--
-- {{marker}} inserts the value from config.marker. Each log statement should have one, so that the line can be removed via .removeLogs().
-- {{var}}: variable as described further above.
-- {{time}}: timestamp formatted as HH:MM:SS (for millisecond-precision, use .timeLog() instead)
-- {{filename}}: basename of the current file
-- {{lnum}}: current line number
-- .emojiLog() only: {{emoji}} inserts the emoji
-- .timeLog() only: {{index}} inserts a running index. (Needed to differentiate between variables when using timeLog multiple times).

return {
  enabled = false,
  "chrisgrieser/nvim-chainsaw",
  event = "VeryLazy",
  opts = {
    logStatements = {
      messageLog = {
        nvim_lua = "vim.notify('{{filename}}-{{lnum}}-{{marker}}: ')",
      },
    },
  },
}
