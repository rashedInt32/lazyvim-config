return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim", -- Corrected mason dependency
      "mason-org/mason-lspconfig.nvim", -- Corrected mason-lspconfig dependency
    },
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = function()
            return vim.loop.cwd()
          end, -- Fixed: use function
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
          root_dir = function()
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.ts",
              "postcss.config.js",
              "package.json",
              ".git"
            )(vim.fn.getcwd())
          end,
        },
        prismals = {
          filetypes = { "prisma" },
        },
        lua_ls = {
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
      },
    },
    config = function(_, opts)
      -- Ensure Mason is set up first
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "vtsls",
          "tailwindcss",
          "prismals",
          "elixirls",
          "emmet_ls", -- Corrected server name
          "intelephense",
        },
        automatic_enable = false,
      })

      -- Shared on_attach for all servers
      local on_attach = function(client, bufnr)
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

      -- Get lspconfig safely
      local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_ok then
        vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
        return
      end

      -- Setup each server
      -- Setup each server safely
      for server_name, server_opts in pairs(opts.servers) do
        local server = lspconfig[server_name]
        if server then
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, server_opts)
          server.setup(full_opts)
        else
          vim.notify("LSP server not found in lspconfig: " .. server_name, vim.log.levels.WARN)
        end
      end
    end,
  },
}
