return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Assuming lsp_signature is added separately as per previous instructions
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
        prismals = {
          filetypes = { "prisma" }, -- Moved here for consistency
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
      -- allowing lsp_signature.nvim to be the sole handler.
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end
      -- CHANGED: Added to suppress hover diagnostics globally
      vim.lsp.handlers["textDocument/hover"] = function() end

      -- Shared on_attach for all servers: Integrate lsp_signature for signature help control
      local lsp_signature = require("lsp_signature")
      local on_attach = function(client, bufnr)
        -- lsp_signature integration (positions float above cursor, no duplicates)
        lsp_signature.on_attach({
          floating_window_off_y = -1, -- 1 row above cursor (tweak if needed)
        }, bufnr)
      end

      -- Helper to merge on_attach with server opts
      local function setup_server(server_name, server_opts)
        local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, server_opts or {})
        require("lspconfig")[server_name].setup(full_opts)
      end

      -- Global LspAttach autocmd (your existing logic + on_attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.documentHighlightProvider = false
            -- Optional: client.server_capabilities.signatureHelpProvider = false  -- Uncomment to fully disable for a client
          end
          on_attach(client, args.buf) -- Call plugin integration here

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

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "prismals", "elixirls", "emmet_language_server" },
      })

      -- Prisma filetype autocmd (your existing)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.prisma",
        callback = function()
          vim.bo.filetype = "prisma"
        end,
      })

      -- Setup all servers consistently with on_attach (from mason-lspconfig + manual)
      require("mason-lspconfig").setup_handlers({
        -- Default handler for mason-installed servers (e.g., lua_ls)
        function(server_name)
          setup_server(server_name, opts.servers[server_name])
        end,
        -- Override for servers with custom setup (e.g., non-mason or extra opts)
        ["prismals"] = function()
          setup_server("prismals", opts.servers.prismals)
        end,
        ["vtsls"] = function()
          setup_server("vtsls", opts.servers.vtsls)
        end,
        ["tailwindcss"] = function()
          setup_server("tailwindcss", opts.servers.tailwindcss)
        end,
        ["emmet_language_server"] = function()
          setup_server("emmet_language_server", opts.servers.emmet_language_server)
        end,
        ["elixirls"] = function()
          setup_server("elixirls", opts.servers.elixirls)
        end,
        ["intelephense"] = function()
          setup_server("intelephense", opts.servers.intelephense)
        end,
      })
    end,
  },
}
