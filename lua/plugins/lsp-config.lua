return {
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
          prefix = "Error",
        },
      },

      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = vim.loop.cwd,
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

        prismals = {},

        lua_ls = {},
      },

      setup = {
        ["*"] = function(_, opts)
          opts.on_attach = function(client, bufnr)
            -- Only basic hover keymap
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
          end
        end,
      },
    },

    config = function(_, opts)
      -- 🔁 Global LSP tweaks on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.documentHighlightProvider = false
            client.server_capabilities.signatureHelpProvider = false
          end
        end,
      })

      -- 🧼 Disable signatureHelp popup globally
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end

      -- 🔧 Setup Mason + LSPs
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "prismals" },
      })

      -- 📝 Filetype override for *.prisma
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })

      -- 🔌 Prisma LSP (manual setup)
      require("lspconfig").prismals.setup({
        filetypes = { "prisma" },
      })

      -- 🚀 vtsls setup (with opts only, no inline on_attach)
      local lspconfig = require("lspconfig")
      lspconfig.vtsls.setup(opts.servers.vtsls)
    end,
  },
}
