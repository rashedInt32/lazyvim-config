return {
  "oxfist/night-owl.nvim",
  lazy = false, -- load during startup as main colorscheme
  priority = 1000, -- load before other plugins
  opts = {
    transparent_background = true,
  },
  config = function()
    -- load the colorscheme here
    require("night-owl").setup({})
    vim.cmd("colorscheme night-owl")

    local hl = vim.api.nvim_set_hl
    local bg = "NONE"

    -- Transparent backgrounds
    hl(0, "Normal", { bg = bg })
    hl(0, "NormalNC", { bg = bg })
    hl(0, "NormalFloat", { bg = bg })
    hl(0, "EndOfBuffer", { bg = bg })
    hl(0, "FloatBorder", { bg = bg })
    hl(0, "MsgArea", { bg = bg })
    hl(0, "StatusLine", { bg = bg })
    hl(0, "TelescopeNormal", { bg = bg })
    hl(0, "TelescopeBorder", { bg = bg })
  end,
}

-- Fix the background mismatch
--vim.api.nvim_set_hl(0, "Normal", { bg = "#011627" })
--vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#011627" })
