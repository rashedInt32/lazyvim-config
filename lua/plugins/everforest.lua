
local M = {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  vim.o.background = "dark" -- required for everforest
  require("everforest").setup({
    background = "hard",
    transparent_background_level = 0,
    italics = true,
    disable_italic_comments = false,
    on_highlights = function(hl, _)
      hl["@string.special.symbol.ruby"] = { link = "@field" }
    end,
  })
end

return M