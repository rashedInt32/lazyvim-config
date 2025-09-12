return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "ray-x/lsp_signature.nvim", -- Move lsp_signature as dependency
    },
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      servers = {
        -- ... your server configurations remain the same ...
      },
    },
    config = function(_, opts)
      -- Disable default signature help and hover handlers
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end
      vim.lsp.handlers["textDocument/hover"] = function() end

      -- Setup lsp_signature with your desired configuration
      local lsp_signature = require("lsp_signature")
      lsp_signature.setup({
        bind = true,
        debug = false,
        floating_window = true,
        floating_window_above_cur_line = true,
        floating_window_off_y = -1,
        floating_window_off_x = 0,
        floating_window_close_timeout = 4000,
        handler_opts = {
          border = "rounded",
        },
      })

      -- Shared on_attach for all servers
      local on_attach = function(client, bufnr)
        client.server_capabilities.documentHighlightProvider = false

        -- Setup lsp_signature for this buffer
        lsp_signature.on_attach({
          floating_window_off_y = -1,
        }, bufnr)
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
        -- Your specific server overrides...
        ["prismals"] = function()
          local full_opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts.servers.prismals or {})
          require("lspconfig").prismals.setup(full_opts)
        end,
        -- ... repeat for other specific servers if needed
      })
    end,
  },
}
