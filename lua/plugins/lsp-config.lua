return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim", -- Corrected mason dependency
      "mason-org/mason-lspconfig.nvim", -- Corrected mason-lspconfig dependency
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      inlay_hints = { enabled = false },
      document_highlight = { enabled = false },
      servers = {
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
          root_markers = {
            "tailwind.config.js",
            "tailwind.config.ts",
            "postcss.config.js",
            "package.json",
            ".git",
          },
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
          -- The old root_pattern("*.sql", ".git") matched a glob. root_markers
          -- compares exact filenames and cannot express that, so keep the glob
          -- as a predicate, with the same .git fallback as before.
          root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, function(name)
              return name:match("%.sql$") ~= nil
            end) or vim.fs.root(bufnr, { ".git" }))
          end,
        },

        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        elixirls = {
          cmd = { vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/language_server.sh" },
          filetypes = { "elixir", "eelixir", "heex" },
          root_markers = { "mix.exs", ".git" },
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
          workspace_required = true, -- was single_file_support = false
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
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
      -- Configure LSP hover and signature help with borders
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
        },
        automatic_enable = false,
      })

      -- Shared on_attach for all servers
      local on_attach = function(client, bufnr)
        -- Prevent unwanted LSPs on SQL buffers
        local ft = vim.bo[bufnr].filetype
        if ft == "sql" and client.name ~= "postgres_lsp" and client.name ~= "sqls" and client.name ~= "copilot" then
          vim.schedule(function()
            client.stop()
          end)
          return
        end

        client.server_capabilities.documentHighlightProvider = false
      end

      -- LspAttach keymap.
      --
      -- No on_attach call here: it is already passed into each server's config
      -- below, and lspconfig invokes it itself, so calling it again ran the
      -- whole thing twice per client. LspAttach also fires once per client, and
      -- the map is identical for all of them, so guard it per buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          if vim.b[bufnr].diagnostic_float_mapped then
            return
          end
          vim.b[bufnr].diagnostic_float_mapped = true
          vim.keymap.set("n", "<leader>cd", function()
            -- No `source` here: opts passed to open_float override the global
            -- float config, and a source prefix is spliced onto the first line
            -- *after* `format` runs, which shifts effect-error-pretty's box off
            -- its own gutter. config/diagnostics.lua adds the source back to
            -- plain messages inside `format`.
            vim.diagnostic.open_float(nil, {
              scope = "cursor",
              border = "rounded",
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

      -- lspconfig[name].setup() is the pre-0.11 framework. On this Nvim it
      -- launches clients through lspconfig's own registry, out of reach of
      -- vim.lsp.start, so nothing started elsewhere can ever be reused.
      -- Register through vim.lsp.config instead.
      --
      -- Assign by index rather than calling vim.lsp.config(name, cfg). The call
      -- form merges into the config shipped at lsp/<name>.lua, and that merge
      -- is not the one lspconfig performed: it reordered root markers and
      -- pulled in upstream setting defaults. Assigning redefines, which leaves
      -- the merge under our control.
      --
      -- LazyVim merges more into opts.servers than we declare: extras add
      -- jsonls/gopls/bashls, a "*" entry of shared capabilities, and tool names
      -- such as stylua. The old loop indexed lspconfig[name] and skipped
      -- anything it did not recognise, which is where the "config not found"
      -- startup warnings came from. Keep that set, deliberately this time.
      local NOT_A_SERVER = { ["*"] = true, stylua = true }

      -- lspconfig injected its own default capabilities into every server it
      -- set up. Nothing does that here, so clients would advertise far less
      -- than they used to (no snippet support, no completion item resolve).
      -- Register the shared set once, which is what "*" is for, and fold in
      -- LazyVim's own "*" entry since the old loop threw it away.
      vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })

      -- lspconfig tried each marker in turn and its configs listed the project
      -- file before ".git". Several shipped lsp/<name>.lua configs list ".git"
      -- first, which roots a server at the repo top instead of the project dir
      -- (intelephense lands on the repo rather than the composer.json folder).
      -- Demote ".git" to last so today's roots survive.
      local function project_markers_first(markers)
        local rest, git = {}, nil
        for _, m in ipairs(markers) do
          if m == ".git" then
            git = m
          else
            rest[#rest + 1] = m
          end
        end
        if git then
          rest[#rest + 1] = git
        end
        return rest
      end

      local enable = {}
      for server_name, server_opts in pairs(opts.servers) do
        local base = not NOT_A_SERVER[server_name] and vim.lsp.config[server_name] or nil
        if base then
          local merged = vim.tbl_deep_extend("force", base, { on_attach = on_attach }, server_opts)

          -- tbl_deep_extend merges arrays element-wise, which would splice our
          -- lists into the shipped ones. Replace outright where we declare one.
          for _, key in ipairs({ "filetypes", "cmd", "root_markers" }) do
            if server_opts[key] then
              merged[key] = server_opts[key]
            end
          end

          -- root_dir outranks root_markers, and assigning nil cannot unset a
          -- field inherited from the shipped lsp/<name>.lua config: the merge
          -- reads nil as "no override", so its resolver keeps winning and our
          -- markers are silently ignored. Express declared markers as a
          -- resolver instead, which does override. on_dir(nil) means "do not
          -- activate", which is also how workspace_required behaves.
          if server_opts.root_dir then
            merged.root_dir, merged.root_markers = server_opts.root_dir, nil
          elseif server_opts.root_markers then
            local markers = server_opts.root_markers
            merged.root_dir = function(bufnr, on_dir)
              on_dir(vim.fs.root(bufnr, markers))
            end
          elseif merged.root_markers then
            merged.root_markers = project_markers_first(merged.root_markers)
          end

          vim.lsp.config[server_name] = merged
          enable[#enable + 1] = server_name
        end
      end

      vim.lsp.enable(enable)
    end,
  },
}
