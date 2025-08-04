return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "vtsls", "tailwindcss" },
      automatic_installation = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Disable signature help popups
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end

      -- Setup mason
      require("mason").setup()
      require("mason-lspconfig").setup()

      -- Get capabilities (with fallback)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Common on_attach function
      local on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
        vim.keymap.set(
          "n",
          "<leader>D",
          vim.lsp.buf.type_definition,
          { buffer = bufnr, desc = "Go to type definition" }
        )
      end

      -- Configure servers
      local lspconfig = require("lspconfig")

      -- vtsls configuration (will auto-start for TS/JS files)
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_dir = function()
          return vim.loop.cwd()
        end,
        single_file_support = true,
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
      })

      -- TailwindCSS configuration
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
      })

      -- LuaLS configuration
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },
}
