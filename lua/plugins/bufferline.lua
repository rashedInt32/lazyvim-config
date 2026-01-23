return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      always_show_bufferline = false,
      auto_toggle_bufferline = false,
    },
  },
  keys = {
    {
      "<leader>tb",
      function()
        vim.opt.showtabline = vim.o.showtabline == 0 and 2 or 0
      end,
      desc = "Toggle tabline",
    },
  },
  init = function()
    vim.opt.showtabline = 0
  end,
}
