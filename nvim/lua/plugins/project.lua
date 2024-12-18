local DATA = os.getenv("XDG_DATA_HOME")
local STATE = os.getenv("XDG_STATE_HOME")
local CACHE = os.getenv("XDG_CACHE_HOME")

return {
  "ahmedkhalf/project.nvim",
  opts = {
    manual_mode = false,
    exclude_dirs = { DATA, STATE, CACHE },
  },
}
