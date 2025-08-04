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
    },
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      diagnostics = {
        virtual_text = false,
        signs = true,
        underline = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
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
          -- No need to call setup here manually
        },
        tailwindcss = {
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
        lua_ls = {},
      },
      setup = {
        -- Just set on_attach here, no manual setup call
        vtsls = function(_, opts)
          opts.on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
            vim.keymap.set(
              "n",
              "<leader>D",
              vim.lsp.buf.type_definition,
              { buffer = bufnr, desc = "Go to type definition" }
            )
          end
        end,
        ["*"] = function(_, opts)
          opts.on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
            vim.keymap.set(
              "n",
              "<leader>D",
              vim.lsp.buf.type_definition,
              { buffer = bufnr, desc = "Go to type definition" }
            )
          end
        end,
      },
    },
    config = function(_, opts)
      -- Disable all automatic signature help popups globally
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss" },
      })

      -- DO NOT manually call lspconfig setup here!
      -- LazyVim does that for you using opts.servers and opts.setup
    end,
  },
}
