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
          root_dir = vim.loop.cwd, -- Force LSP to use cwd
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
        vtsls = function(_, opts)
          opts.on_attach = function(client, bufnr)
            client.server_capabilities.documentHighlightProvider = false -- <- Add this
            client.server_capabilities.signatureHelpProvider = false
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
          end
          -- DO NOT call setup here
        end,

        ["*"] = function(_, opts)
          opts.on_attach = function(client, bufnr)
            client.server_capabilities.documentHighlightProvider = false -- <- Add this
            client.server_capabilities.signatureHelpProvider = false
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover (type info)" })
          end
        end,
      },
    },

    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          client.server_capabilities.documentHighlightProvider = false
        end,
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "prismals" },
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })

      require("lspconfig").prismals.setup({
        filetypes = { "prisma" },
      })

      local lspconfig = require("lspconfig")

      if opts.servers.vtsls then
        local vtsls_opts = vim.tbl_deep_extend("force", opts.servers.vtsls, {
          root_dir = function()
            return vim.loop.cwd()
          end,
          single_file_support = true,
        })

        lspconfig.vtsls.setup(vtsls_opts)

        -- Safe auto-attach for JS/TS filetypes
        local filetypes = vtsls_opts.filetypes
          or {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          }

        vim.api.nvim_create_autocmd("BufReadPost", {
          callback = function(args)
            local buf = args.buf
            local ft = vim.bo[buf].filetype
            if vim.tbl_contains(filetypes, ft) then
              local clients = vim.lsp.get_clients({ bufnr = buf, name = "vtsls" })
              if #clients == 0 then
                lspconfig.vtsls.manager.try_add_wrapper(buf)
              end
            end
          end,
        })
      end
    end,
  },
}
