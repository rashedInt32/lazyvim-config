return {
  -- Local checkout while the plugin is in development. Switch to
  -- "rashedInt32/jury.nvim" once it is published.
  dir = vim.fn.expand("~/Documents/codes/packages/jury.nvim"),
  name = "jury.nvim",
  dependencies = { "effect-error-pretty.nvim" },
  event = "LspAttach",
  cmd = { "Jury" },
  opts = {
    -- Key: $TYPESAFE_API_KEY, else ~/.config/typesafe/key.
    min_confidence = 0.6,
  },
}
