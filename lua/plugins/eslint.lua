return {
  "esmuellert/nvim-eslint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-eslint").setup({
      debug = false,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
        "astro",
      },
      settings = {
        validate = "on",
        useESLintClass = true,
        useFlatConfig = function(bufnr)
          return require("nvim-eslint").use_flat_config(bufnr)
        end,
        experimental = { useFlatConfig = false },
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          },
        },
        codeActionOnSave = { mode = "all" },
        format = false,
        quiet = false,
        onIgnoredFiles = "off",
        options = {},
        rulesCustomizations = {},
        run = "onType",
        problems = { shortenToSingleLine = false },
        workingDirectory = { mode = "auto" },
      },
    })
  end,
}
