return {
  "neovim/nvim-lspconfig",
  init = function()
    local diagnostics_enabled = true

    local function apply_diagnostic_config(enabled)
      vim.diagnostic.config({
        virtual_text = enabled,
        signs = enabled,
        underline = enabled,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end

    -- Initial config
    apply_diagnostic_config(true)

    -- Toggle function
    local function toggle_diagnostics()
      diagnostics_enabled = not diagnostics_enabled
      apply_diagnostic_config(diagnostics_enabled)

      vim.notify(
        diagnostics_enabled and "Diagnostics enabled" or "Diagnostics disabled",
        diagnostics_enabled and vim.log.levels.INFO or vim.log.levels.WARN,
        { title = "LSP" }
      )
    end

    -- Auto hide/show on Insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        if diagnostics_enabled then
          apply_diagnostic_config(false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        if diagnostics_enabled then
          apply_diagnostic_config(true)
        end
      end,
    })

    -- Command + keymap
    vim.api.nvim_create_user_command("ToggleDiagnostics", toggle_diagnostics, {})
    vim.keymap.set("n", "<leader>ud", toggle_diagnostics, {
      desc = "Toggle Diagnostics (Insert-Sensitive)",
      silent = true,
    })
  end,
}
