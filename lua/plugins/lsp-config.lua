return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim", -- Corrected mason dependency
      "mason-org/mason-lspconfig.nvim", -- Corrected mason-lspconfig dependency
    },
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      servers = {
        copilot = {
          cmd = { "copilot", "lsp" },
          root_dir = require("lspconfig.util").root_pattern(".git", vim.fn.getcwd()),
        },
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "scss",
            --"javascript",
            --"typescript",
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
          on_attach = function(client, bufnr)
            if vim.bo[bufnr].filetype == "sql" then
              client.stop()
            end
          end,
        },
        prismals = {
          filetypes = { "prisma" },
        },
        postgres_lsp = {
          filetypes = { "sql" },
          root_dir = require("lspconfig.util").root_pattern("*.sql", ".git"),
        },

        lua_ls = {
          enable = false,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
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
        emmet_ls = { -- Corrected server name
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
          filetypes = { "php" },
          settings = {
            intelephense = {
              format = {
                enable = false,
                tabSize = 4,
                insertSpaces = true,
              },
            },
          },
        },
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          single_file_support = false,
          root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
          settings = {
            typescript = {
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
              preferences = {
                importModuleSpecifier = "non-relative",
                quoteStyle = "single",
              },
            },
            javascript = {
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
              preferences = {
                importModuleSpecifier = "non-relative",
                --quoteStyle = "single",
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
          },
        },
      },
    },

    config = function(_, opts)
      -- Ensure Mason is set up first
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tailwindcss",
          "prismals",
          "elixirls",
          "emmet_ls",
          "intelephense",
          "sqls",
          "vtsls",
          "copilot",
        },
        automatic_enable = false,
      })

      -- Shared on_attach for all servers
      local on_attach = function(client, bufnr)
        -- Prevent unwanted LSPs on SQL buffers
        local ft = vim.bo[bufnr].filetype
        if ft == "sql" and client.name ~= "postgres_lsp" and client.name ~= "sqls" then
          vim.schedule(function()
            client.stop()
          end)
          return
        end

        client.server_capabilities.documentHighlightProvider = false
      end

      -- LspAttach keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client then
            on_attach(client, bufnr)
          end
          vim.keymap.set("n", "<leader>cd", function()
            vim.diagnostic.open_float(nil, {
              scope = "cursor",
              border = "rounded",
              source = "always",
              focus = false,
              max_width = 100,
              max_height = 30,
            })
          end, { buffer = bufnr, desc = "Open floating diagnostics" })
        end,
      })

      -- Prisma filetype autocmd
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })

      -- SQL filetype autocmd (force correct ft detection)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.sql",
        callback = function()
          vim.bo.filetype = "sql"
        end,
      })

      -- Get lspconfig safely
      local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_ok then
        vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
        return
      end

      for server_name, server_opts in pairs(opts.servers) do
        local server = lspconfig[server_name]
        if server and server.setup then
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, server_opts)
          server.setup(full_opts)
        end
      end
    end,
  },
}
