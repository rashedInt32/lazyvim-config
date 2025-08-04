return {
  -- ... your mason and mason-lspconfig config unchanged ...

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- other opts unchanged ...

      servers = {
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          -- Remove root_dir or set to cwd to force always start
          root_dir = vim.loop.cwd, -- always current directory (no root detection)
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
        -- other servers unchanged ...
      },
      setup = {
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
          -- DO NOT call lspconfig.vtsls.setup(opts) here!
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
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss" },
      })

      local lspconfig = require("lspconfig")

      -- Setup vtsls with global root_dir to always start the LSP
      if opts.servers.vtsls then
        local vtsls_opts = vim.tbl_deep_extend("force", opts.servers.vtsls, {
          root_dir = function()
            return vim.loop.cwd()
          end,
          single_file_support = true,
        })

        -- Attach manually to matching buffers
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
                vim.defer_fn(function()
                  vim.lsp.buf_attach_client(buf, vim.lsp.start_client(vtsls_opts))
                end, 0)
              end
            end
          end,
        })

        lspconfig.vtsls.setup(vtsls_opts)
      end
    end,
  },
}
