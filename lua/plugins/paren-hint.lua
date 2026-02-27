return {
  "briangwaltney/paren-hint.nvim",
  lazy = false,
  config = function()
    -- custom highlight group - slightly darker than comment color (#7a9a9a)
    vim.api.nvim_set_hl(0, "parenhint", { fg = "#5d7d7d" })

    require("paren-hint").setup({
      -- Include the opening paren in the ghost text
      include_paren = true,

      -- Show ghost text when cursor is anywhere on the line that includes the close paren rather just when the cursor is on the close paren
      anywhere_on_line = true,

      -- show the ghost text when the opening paren is on the same line as the close paren
      show_same_line_opening = false,

      -- style of the ghost text using highlight group
      -- :Telescope highlights to see the available highlight groups if you have telescope installed
      highlight = "parenhint",

      -- excluded filetypes
      excluded_filetypes = {
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "TelescopeResults",
        "",
      },
      -- excluded buftypes
      excluded_buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    })
  end,
}
