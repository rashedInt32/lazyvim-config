return {
  "oxfist/night-owl.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    transparent_background = true,
  },
  config = function()
    -- load the colorscheme here
    require("night-owl").setup({})
    vim.cmd.colorscheme("night-owl")

    -- Optional: manually override just in case
    -- Set transparency after the theme is applied
    local hl = vim.api.nvim_set_hl
    local bg = "NONE"

    hl(0, "Normal", { bg = bg })
    hl(0, "NormalNC", { bg = bg })
    hl(0, "NormalFloat", { bg = bg })
    hl(0, "EndOfBuffer", { bg = bg })
    hl(0, "FloatBorder", { bg = bg })
    hl(0, "MsgArea", { bg = bg })
    hl(0, "StatusLine", { bg = bg })
    hl(0, "TelescopeNormal", { bg = bg })
    hl(0, "TelescopeBorder", { bg = bg })
    -- Fix the background mismatch
    --vim.api.nvim_set_hl(0, "Normal", { bg = "#011627" })
    --vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#011627" })
  end,
}
