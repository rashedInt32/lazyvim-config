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
      -- REMOVED: diagnostics table to defer to options.lua
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

        elixirls = {
          cmd = { vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/language_server.sh" },
          filetypes = { "elixir", "eelixir", "heex" },
          root_dir = require("lspconfig.util").root_pattern("mix.exs", ".git"),
          settings = {
            elixirLS = {
              dialyzerEnabled = false,
              fetchDeps = false,
            },
          },
        },

        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
          },
        },
        intelephense = {
          filetypes = { "php" }, -- Ensure Blade isn't included
          settings = {
            intelephense = {
              format = {
                enable = false, -- Disable Intelephense formatting to let blade-formatter handle it
                tabSize = 4,
                insertSpaces = true,
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.documentHighlightProvider = false
            --client.server_capabilities.signatureHelpProvider = false
          end
          -- CHANGED: Added keymap for manual floating diagnostics
          vim.keymap.set("n", "<leader>cd", function()
            vim.diagnostic.open_float(nil, {
              scope = "cursor",
              border = "rounded",
              source = "always",
              focus = false,
            })
          end, { buffer = args.buf, desc = "Open floating diagnostics" })
        end,
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end
      -- CHANGED: Added to suppress hover diagnostics globally
      vim.lsp.handlers["textDocument/hover"] = function()
        return
      end
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "prismals", "elixirls" },
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })
      require("lspconfig").prismals.setup({ filetypes = { "prisma" } })
      require("lspconfig").vtsls.setup(opts.servers.vtsls)
      require("lspconfig").tailwindcss.setup(opts.servers.tailwindcss)
      require("lspconfig").emmet_language_server.setup(opts.servers.emmet_language_server)
      require("lspconfig").elixirls.setup(opts.servers.elixirls)
    end,
  },
}
