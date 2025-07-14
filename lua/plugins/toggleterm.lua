return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "tab", -- Keep tab direction
      size = 20,
      start_in_insert = true,
      close_on_exit = true,
      hide_numbers = true,
      persist_size = true,
      persist_mode = true,
      autochdir = true,
    },
  },
}
