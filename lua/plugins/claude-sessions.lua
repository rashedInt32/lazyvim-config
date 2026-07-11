-- Machine-wide Claude Code agent awareness: statusline dots, the tmux picker
-- bridge, and the RPC endpoints tmux-claude-session-manager's picker calls for
-- sidekick-embedded agents. Extracted from lua/config/claude_sessions.lua into
-- a real plugin.
return {
  "rashedInt32/claude-sessions.nvim",
  event = "VeryLazy",
  opts = {
    -- Match the lualine section background so the dimmed "own agent" dots
    -- blend toward the right color.
    statusline = { bg = "#01111d" },
    -- Ctrl-L to embedded Claude terminals on FocusGained: clears the ghost
    -- rows Ink leaves over the input box after a tmux session switch.
    -- (Replaces the autocmd that used to live in plugins/sidekick.lua.)
    repaint = { enabled = true },
  },
}
