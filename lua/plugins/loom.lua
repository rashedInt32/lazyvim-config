return {
  -- Local checkout while the plugin is in development. Owns <C-/> and <C-\>,
  -- which used to open Snacks.terminal (see plugins/snacks.lua).
  dir = vim.fn.expand("~/Documents/codes/packages/loom.nvim"),
  name = "loom.nvim",
  lazy = false,
  opts = {
    -- Same key as the tmux prefix. tmux hands C-a to nvim while a loom pane
    -- has focus (the @loom binding in tmux.conf), and keeps it everywhere else.
    prefix = "<C-a>",
    -- The lualine pills (plugins/lualine.lua): terminal-mode blue for the
    -- active tab, branch green for the session, location gold for the prefix.
    colors = {
      active = "#82aaff",
      active_fg = "#131314",
      session = "#90b99f",
      prefix = "#e6b99d",
    },
  },
}
