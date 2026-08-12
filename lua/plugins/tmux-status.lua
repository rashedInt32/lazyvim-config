-- Hides tmux's own status bar while nvim is focused, so it doesn't stack
-- underneath lualine. Restored on FocusLost, VimSuspend and VimLeavePre.
-- The plugin also ships lualine components; none are wired up here.
return {
  {
    "christopher-francisco/tmux-status.nvim",
    event = "VeryLazy",
    opts = {
      manage_tmux_status = true,
    },
  },
}
