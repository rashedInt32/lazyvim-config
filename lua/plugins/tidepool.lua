return {
  -- Local checkout so theme edits apply instantly. Swap `dir` for
  -- "rashedInt32/tidepool.nvim" once it is published.
  dir = "~/Documents/codes/packages/tidepool.nvim",
  name = "tidepool.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- "muted" original | "lifted" everything brighter | "hybrid" lifted content,
    -- muted scaffolding. Hex tables in the repo's PALETTE-LIFT.md.
    palette = "hybrid",
    transparent = true,
    -- Trial: slant parameters and module names only (rose-pine flavor).
    styles = { italic_identifiers = true },
  },
  config = function(_, opts)
    -- Active colorscheme: config/lazy.lua points LazyVim at tidepool.
    -- No `colorscheme` call here — LazyVim applies it once at startup.
    require("tidepool").setup(opts)
  end,
}
