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
  -- These were bare vim.keymap.set() calls sitting as elements of this table,
  -- so they ran at spec-parse time and left nil holes in the spec. As real
  -- `keys` entries they also lazy-load the plugin instead of forcing it.
  --
  -- Workspace moved from <leader>sw to <leader>sS: <leader>sw is Snacks
  -- grep_word, which lazy registers later, so the Namu map never survived.
  keys = {
    { "<leader>ss", "<cmd>Namu symbols<cr>", desc = "Jump to LSP symbol", silent = true },
    { "<leader>sS", "<cmd>Namu workspace<cr>", desc = "LSP Symbols - Workspace", silent = true },
  },
}
