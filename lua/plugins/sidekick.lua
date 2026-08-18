return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    nes = { enabled = true },
    cli = {
      tools = {
        claude = {
          cmd = { "claude", "--model", "claude-opus-5" },
        },
        claude_fable = {
          cmd = { "claude", "--model", "claude-fable-5" },
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
    -- Sidekick paints its terminal with SidekickChat (default-linked to
    -- NormalFloat), so Claude's unstyled body text ignores Ghostty's dimmed
    -- foreground. Redefine it with the same fg as the terminal (a4b6ca) so
    -- inline-code highlights (#b7d6fb) and bold stand out here too. The
    -- plugin's `default = true` link never overrides this explicit definition.
    local function dim_chat_text()
      local float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
      vim.api.nvim_set_hl(0, "SidekickChat", { fg = "#a4b6ca", bg = float.bg })
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
