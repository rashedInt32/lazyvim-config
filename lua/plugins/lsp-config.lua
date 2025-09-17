return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/lazydev.nvim", ft = "lua" },
      -- REMOVED: "ray-x/lsp_signature.nvim"
    },
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
        prismals = {
          filetypes = { "prisma" },
        },
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
      -- REMOVED: Disabling default handlers - let Noice handle them
      -- vim.lsp.handlers["textDocument/signatureHelp"] = function() end
      -- vim.lsp.handlers["textDocument/hover"] = function() end

      -- REMOVED: lsp_signature setup
      -- local lsp_signature = require("lsp_signature")
      -- lsp_signature.setup({...})

      -- Shared on_attach for all servers
      local on_attach = function(client, bufnr)
        client.server_capabilities.documentHighlightProvider = false

        -- REMOVED: lsp_signature on_attach
        -- lsp_signature.on_attach({...}, bufnr)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client then
            on_attach(client, bufnr)
          end

          -- Keymap for manual floating diagnostics
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

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "prismals", "elixirls", "emmet_language_server" },
      })

      -- Prisma filetype autocmd
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })

      -- Setup all servers
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local server_opts = opts.servers[server_name] or {}
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, server_opts)
          require("lspconfig")[server_name].setup(full_opts)
        end,
        ["prismals"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.prismals or {})
          require("lspconfig").prismals.setup(full_opts)
        end,
        ["vtsls"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.vtsls or {})
          require("lspconfig").vtsls.setup(full_opts)
        end,
        ["tailwindcss"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.tailwindcss or {})
          require("lspconfig").tailwindcss.setup(full_opts)
        end,
        ["emmet_language_server"] = function()
          local full_opts =
            vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.emmet_language_server or {})
          require("lspconfig").emmet_language_server.setup(full_opts)
        end,
        ["elixirls"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.elixirls or {})
          require("lspconfig").elixirls.setup(full_opts)
        end,
        ["intelephense"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.intelephense or {})
          require("lspconfig").intelephense.setup(full_opts)
        end,
      })
    end,
  },
}
