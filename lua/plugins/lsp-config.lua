return {
  -- Mason: Package manager for LSP servers
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Mason-LSPConfig: Bridge between Mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "tsserver" }, -- Example servers
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false }, -- <--- ADD THIS LINE HERE
      servers = {
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        tailwindcss = {
          -- optional config
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
          },
          root_dir = require("lspconfig.util").root_pattern(
            "tailwind.config.js",
            "tailwind.config.ts",
            "postcss.config.js",
            "package.json",
            ".git"
          ),
        },
      },
      -- The 'setup' key here is for configuring specific servers,
      -- but the global document_highlight should be in the main opts.
      -- You can remove this 'setup' table if you prefer to set up servers directly in `config`
      -- or allow mason-lspconfig to handle the defaults.
      setup = {
        vtsls = function(_, opts)
          require("lspconfig").vtsls.setup(opts)
        end,
      },
    },
    config = function()
      -- These calls are fine, they ensure the servers are set up if Mason installs them.
      -- If you want to customize options for these, you'd pass a table to setup().
      -- However, the global `document_highlight = { enabled = false }` should cover it.
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Your mason-lspconfig setup here
      })

      -- Setup language servers
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({}) -- Will now inherit the global document_highlight = false
      lspconfig.tsserver.setup({}) -- Will now inherit the global document_highlight = false
      lspconfig.tailwindcss.setup({}) -- Will now inherit the global document_highlight = false
    end,
  },
}
