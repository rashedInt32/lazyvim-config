return {
  {
    "rashedInt32/effect-error-pretty.nvim",
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
