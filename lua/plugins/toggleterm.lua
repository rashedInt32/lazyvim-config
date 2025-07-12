return {
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- Use latest version
    event = "VeryLazy", -- Load with LazyVim
    opts = {
      open_mapping = [[<C-\>]], -- Toggle with Ctrl+\
      direction = "tab", -- Use floating terminal
      size = 20, -- Height for float/horizontal
      start_in_insert = true, -- Enter insert mode on open
      close_on_exit = true, -- Close terminal when process exits
      hide_numbers = true, -- Hide line numbers
      persist_size = true, -- Persist terminal size
      persist_mode = true, -- Persist insert/normal mode
      float_opts = {
        border = "curved", -- Border style
        width = math.floor(vim.o.columns * 0.9), -- 90% of window width
        height = 20, -- Fixed height
        winblend = 0, -- Opaque background
        -- Position at the bottom
        row = vim.o.lines - 20 - 3, -- Adjust for bottom placement (accounts for border/statusline)
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.9)) / 2), -- Center horizontally
        anchor = "SW", -- Anchor to bottom-left (South-West)
      },
    },
  },
}
