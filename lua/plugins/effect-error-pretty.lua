return {
  {
    -- https://github.com/rashedInt32/effect-error-pretty.nvim — swap `dir` for
    -- "rashedInt32/effect-error-pretty.nvim" to consume the GitHub version.
    --"rashedInt32/effect-error-pretty.nvim",
    dir = "~/Documents/codes/packages/effect-error-pretty.nvim",
    name = "effect-error-pretty.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      effect = true,
      format_ts_errors_fallback = true,
      -- float = false: diagnostics.lua wires the format function manually
      -- so it can layer our icons + suffix on top.
    },
  },
}
