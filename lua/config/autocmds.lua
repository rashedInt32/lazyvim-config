-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- ~/.config/nvim/lua/autocommands.lua
return {
  {
    event = "LspAttach",
    opts = {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.documentHighlightProvider = false
      end,
    },
  },
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  }),
}
