return {
  "bassamsdata/namu.nvim",
  opts = {
    global = {},
    namu_symbols = { -- Specific Module options
      options = {
        display = {
          mode = "icon", -- "icon" or "text"
        },
      },
    },
  },
  -- === Suggested Keymaps: ===
  vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
    desc = "Jump to LSP symbol",
    silent = true,
  }),
  vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
    desc = "LSP Symbols - Workspace",
    silent = true,
  }),
}
