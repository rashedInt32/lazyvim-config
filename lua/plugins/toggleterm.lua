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
    config = function(_, opts)
      require("toggleterm").setup(opts)
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          vim.opt_local.mouse = ""
          local opts = { buffer = 0, noremap = true, silent = true }
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        end,
      })
    end,
  },
}
