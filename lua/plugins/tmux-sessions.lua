-- Every tmux session, a <leader>N away, with a popup for browsing.
--
-- This is needed *because* lua/config/tmux.lua hides tmux's own status bar
-- while nvim owns the pane: the pill bar from tmux-sessions.tmux is invisible
-- from in here, so nvim needs its own view of the same list.
--
-- The always-on ghost text is off. It reads as noise once you know the numbers,
-- and the numbers are the point -- <leader>3 works whether or not anything is
-- drawn. `:TmuxSessionsToggle` brings it back for as long as you want it.
return {
  -- https://github.com/rashedInt32/tmux-sessions.nvim — swap `dir` for
  -- "rashedInt32/tmux-sessions.nvim" to consume the GitHub version instead.
  --"rashedInt32/tmux-sessions.nvim"
  dir = "~/Documents/codes/packages/tmux-sessions.nvim",
  name = "tmux-sessions.nvim",
  event = "VeryLazy",
  opts = {
    -- <leader>1..9 jump, <leader>0 goes back. <leader>ts joins the existing
    -- <leader>t group (td/tf/tb), so it shadows nothing and waits out no
    -- timeoutlen — the problem harpoon.lua documents for <leader>a.
    keys = {
      picker = "<leader>ts",
    },
    ghost = {
      -- Off by default; :TmuxSessionsToggle flips it back on in place.
      enabled = false,
      layout = "vertical",
      name_width = 20,
      -- zindex 10 sits under noice's floats, so a notification takes the corner
      -- rather than fighting for it.
      zindex = 10,
      hide_in_insert = false,
    },
  },
}
