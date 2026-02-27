return {
  "ThePrimeagen/99",
  dependencies = { "saghen/blink.cmp", { "saghen/blink.compat", version = "2.*" } },
  config = function()
    local _99 = require("99")
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      -- Provider selection (default: OpenCodeProvider)
      -- Available providers:
      --   _99.Providers.OpenCodeProvider (default, uses `opencode` CLI)
      --   _99.Providers.ClaudeCodeProvider (uses `claude` CLI)
      --   _99.Providers.CursorAgentProvider (uses `cursor-agent` CLI)
      --   _99.Providers.GeminiCLIProvider (uses `gemini` CLI)
      -- provider = _99.Providers.OpenCodeProvider,

      -- Model override (uses provider default if not set)
      model = "ollama-cloud/kimi-k2.5",

      -- Logging configuration
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },

      -- Temporary directory for operations
      tmp_dir = "./tmp",

      -- Completion settings (for #rules and @files autocomplete)
      completion = {
        -- Completion engine: "cmp" or "blink"
        source = "blink",

        -- Directories containing SKILL.md files
        -- Expected format: /path/to/dir/<skill_name>/SKILL.md
        custom_rules = {},

        -- File completion settings
        files = {
          enabled = true,
          max_file_size = 102400, -- 100KB
          max_files = 5000,
          exclude = { ".env", ".env.*", "node_modules", ".git" },
        },
      },

      -- Auto-add files based on request location
      -- If you're at /foo/bar/baz.lua, will look for:
      --   /foo/bar/AGENT.md
      --   /foo/AGENT.md
      md_files = {
        "AGENT.md",
      },

      -- In-flight request display options
      -- in_flight_options = {
      --   enable = true,
      --   in_flight_interval = 1000,
      --   throbber_opts = {},
      -- },

      -- Additional options
      -- display_errors = true,
      -- auto_add_skills = true,
    })

    -- Core keymaps

    -- Visual mode: Send visual selection with prompt, replace with results
    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end)

    -- Normal mode: Stop all in-flight requests
    vim.keymap.set("n", "<leader>9x", function()
      _99.stop_all_requests()
    end)

    -- Normal mode: Search project with prompt (results in quickfix list)
    vim.keymap.set("n", "<leader>9s", function()
      _99.search()
    end)

    -- Normal mode: View recent logs (navigate older/newer)
    vim.keymap.set("n", "<leader>9l", function()
      _99.view_logs()
    end)

    -- Normal mode: Open selection window for last interaction
    vim.keymap.set("n", "<leader>9o", function()
      _99.open()
    end)

    -- Normal mode: Clear all previous search/visual operations
    vim.keymap.set("n", "<leader>9c", function()
      _99.clear_previous_requests()
    end)

    -- Example: Auto-debug action with pre-defined prompt
    -- vim.keymap.set("n", "<leader>9d", function()
    --   _99.search({
    --     additional_prompt = [[
    --       run `make test` and debug the test failures
    --       and provide me a comprehensive set of steps
    --       where the tests are breaking
    --     ]]
    --   })
    -- end)

    -- Example: Vibe coding mode
    -- vim.keymap.set("n", "<leader>9V", function()
    --   _99.vibe()
    -- end)

    -- Telescope integration (if using telescope)
    -- vim.keymap.set("n", "<leader>9m", function()
    --   require("99.extensions.telescope").select_model()
    -- end)
    -- vim.keymap.set("n", "<leader>9p", function()
    --   require("99.extensions.telescope").select_provider()
    -- end)

    -- fzf-lua integration (if using fzf-lua)
    -- vim.keymap.set("n", "<leader>9m", function()
    --   require("99.extensions.fzf_lua").select_model()
    -- end)
    -- vim.keymap.set("n", "<leader>9p", function()
    --   require("99.extensions.fzf_lua").select_provider()
    -- end)
  end,
}
