return {
  {
    "talha-akram/noctis.nvim",
    lazy = false, -- Load immediately to avoid flashing
    priority = 1000, -- Load early to prevent color scheme flashing
    config = function()
      vim.cmd([[colorscheme noctis_azureus]])
      vim.api.nvim_set_hl(0, "Normal", { bg = "#051b29" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#051b29" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#051b29" })
    end,
  },
}
