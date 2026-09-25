return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    nes = { enabled = true },
    cli = {
      tools = {
        -- claude-hl (~/.local/bin, github.com/rashedInt32/claude-hl) wraps the
        -- real CLI in a PTY and colours shell commands in its output; every
        -- arg passes through unchanged. Swap back to "claude" to bypass it.
        -- --allow-dangerously-skip-permissions ARMS bypass mode in the
        -- Shift+Tab cycle without activating it (same as the zshrc alias).
        claude = {
          cmd = { "claude-hl", "--allow-dangerously-skip-permissions", "--model", "claude-opus-5-5" },
        },
        claude_fable = {
          cmd = { "claude-hl", "--allow-dangerously-skip-permissions", "--model", "claude-fable-5" },
        },
        claude_fable_51 = {
          cmd = { "claude-hl", "--allow-dangerously-skip-permissions", "--model", "claude-fable-5-1" },
        },
      },
      mux = {
        backend = "tmux",
        enabled = false,
        create = "terminal",
      },
      win = {
        -- Pin the terminal view to the bottom in normal mode. Without this the
        -- global `scrolloff` (8) scrolls the Claude TUI up on every mode change,
        -- making the input box render over the top border / shift out of place.
        wo = { scrolloff = 0 },
        -- Double escape to exit terminal mode (like snacks terminal)
        keys = {
          term_normal = {
            "<esc>",
            function(self)
              self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
              if self.esc_timer:is_active() then
                self.esc_timer:stop()
                vim.cmd("stopinsert")
              else
                self.esc_timer:start(200, 0, function() end)
                return "<esc>"
              end
            end,
            mode = "t",
            expr = true,
            desc = "Double escape to normal mode",
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    -- Session discovery runs synchronously before the terminal window is even
    -- created, and it queries every registered backend. Profiled at 212ms per
    -- open: 95ms in the opencode backend (a system-wide `lsof -iTCP`) and
    -- 100ms in tmux (`ps -u $USER -ww` plus `lsof -d cwd` per Claude pane,
    -- ~35ms each, so it grows with the number of live sessions).
    -- Neither backend is wanted here: opencode is unused, and `mux.enabled`
    -- above is false, which session/init.lua ignores when registering. Dropping
    -- both takes discovery to <1ms and stops the tmux panes turning
    -- <leader>ac into a picker. External tmux agents stay discoverable through
    -- claude-sessions.nvim, which reads sidekick's terminal list directly.
    local Session = require("sidekick.cli.session")
    Session.setup() -- loads the tools; backends self-register during this call
    Session.backends.opencode = nil
    Session.backends.tmux = nil
    -- Sidekick paints its terminal with SidekickChat (default-linked to
    -- NormalFloat), so Claude's unstyled body text ignores Ghostty's dimmed
    -- foreground. Redefine it with the same fg as the terminal (94a4b6, Ghostty's
    -- `foreground`; keep the two in sync) so
    -- inline-code highlights (#b7d6fb) and bold stand out here too. The
    -- plugin's `default = true` link never overrides this explicit definition.
    local function dim_chat_text()
      local float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
      vim.api.nvim_set_hl(0, "SidekickChat", { fg = "#94a4b6", bg = float.bg })
    end
    dim_chat_text()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = dim_chat_text })
    -- Zen workspace (sidekick-zen.nvim, plugins/sidekick-zen.lua) is on
    -- <leader>z and adopts these terminals when toggled.
  end,
  -- The FocusGained Ctrl-L ghost-repaint fix that used to live here moved into
  -- claude-sessions.nvim (`repaint.enabled = true` in plugins/claude-sessions.lua).
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<C-_>",
      function()
        -- Exit terminal-mode first so the toggle runs reliably from the chat input
        require("sidekick.cli").focus({ focus = true })
      end,
      desc = "Sidekick Toggle (focus)",
      mode = { "n", "t", "i", "x" },
      silent = true,
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick Toggle CLI (focus)",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
    -- Was <leader>aco -> tool "claude_46", which cli.tools above never defined,
    -- so the key errored. Point it at the second tool that *is* defined, and
    -- move it off the <leader>ac prefix so neither key waits on timeoutlen.
    {
      "<leader>aF",
      function()
        require("sidekick.cli").toggle({ name = "claude_fable", focus = true })
      end,
      desc = "Sidekick Toggle Claude (Fable 5)",
    },
  },
}
