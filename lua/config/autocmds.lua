-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- ~/.config/nvim/lua/autocommands.lua

-- ~/.config/nvim/lua/autocommands.lua
local M = {}

function M.setup()
  -- Disable documentHighlightProvider on LSP attach
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities then
        client.server_capabilities.documentHighlightProvider = false
      end
    end,
  })

  -- Transparent background for Snacks.nvim explorer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks", -- change if Snacks.nvim uses different filetype
    callback = function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.opt_local.cursorline = false
    end,
  })
end

return M
