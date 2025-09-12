return {
  "ray-x/lsp_signature.nvim",
  event = "BufReadPre", -- Lazy-load on buffer read
  opts = {
    bind = true, -- Auto-bind to LSP clients
    debug = false, -- Set to true for logging if issues arise
    floating_window = true, -- Enable the float (set false for virtual text only)
    floating_window_above_cur_line = true, -- Prioritize above cursor to avoid overlap
    floating_window_off_y = -1, -- 1 row above cursor (tweak to -2 if too close)
    floating_window_off_x = 0, -- No horizontal shift (or +5 for rightward nudge)
    floating_window_close_timeout = 4000, -- Auto-hide after 4s inactivity
    handler_opts = {
      border = "rounded", -- Matches your Noice style
    },
    -- Optional: Keymaps in the float (e.g., <C-k> to jump up signatures)
    extra_keymaps = function() -- No default keymaps; add if wanted
      return {
        select_signature_key = "<C-s>", -- Cycle signatures
        close_signature_key = "<C-e>", -- Manual close
      }
    end,
  },
}
