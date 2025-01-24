return {
  "mrjones2014/smart-splits.nvim",
  -- build = "./kitty/install-kittens.bash",
  opts = {
    at_edge = "wrap",
    float_win_behavior = "mux",
  },
  -- only enabled outside of tmux
  -- enabled = (os.getenv("TMUX")) == nil,
}
