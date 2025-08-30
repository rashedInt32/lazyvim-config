return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      size = 20,
      start_in_insert = true,
      close_on_exit = true,
      hide_numbers = true,
      persist_size = true,
      persist_mode = false,
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.95), -- 90% of editor width
        height = math.floor(vim.o.lines * 0.95), -- 90% of editor height
        winblend = 0,
        row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.95)) / 2), -- center vertically
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.95)) / 2), -- center horizontally
        anchor = "NW",
        zindex = 20,
      },
    },
  },
}
