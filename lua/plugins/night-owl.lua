return {
  "oxfist/night-owl.nvim",
  enabled = false,
  lazy = false, -- load during startup as main colorscheme
  priority = 1000, -- load before other plugins
  opts = {},
  config = function()
    -- load the colorscheme here
    require("night-owl").setup({
      transparent_background = true,
    })
    --vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#585b70", italic = true })
  end,
}
