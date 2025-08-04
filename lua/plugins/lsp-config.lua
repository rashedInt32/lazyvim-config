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
          root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
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

      -- Manually setup vtsls with options from opts.servers.vtsls
      local lspconfig = require("lspconfig")
      if opts.servers.vtsls then
        -- Inject on_attach from opts.setup.vtsls if present
        local vtsls_opts = vim.tbl_deep_extend("force", opts.servers.vtsls, {})
        if opts.setup.vtsls then
          opts.setup.vtsls(nil, vtsls_opts)
        end
        lspconfig.vtsls.setup(vtsls_opts)
      end

      -- You can still let LazyVim handle other servers automatically
    end,
  },
}
