return {
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000,
  opts = {
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {},
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin")
  end,
}