-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     vim.api.nvim_clear_autocmds({ event = { "FocusLost", "FocusGained" } })
--     vim.api.nvim_set_hl(0, "Visual", { bg = "#2c313c" }) -- or whatever color you prefer
--   end,
-- })

return {
  -- Override Night Owl Visual highlight focus behavior
  {
    event = "ColorScheme",
    pattern = "night-owl",
    opts = {
      callback = function()
        vim.cmd([[
          highlight Normal guibg=NONE
          highlight NormalNC guibg=NONE
          highlight EndOfBuffer guibg=NONE
        ]])

        local group = vim.api.nvim_create_augroup("MyOverrideVisual", { clear = true })

        local function force_active_visual()
          vim.cmd("hi! link Visual @nowl.visual.active")
        end

        -- Apply immediately
        force_active_visual()

        -- Re-apply on focus changes
        vim.api.nvim_create_autocmd({ "FocusGained", "FocusLost" }, {
          pattern = "*",
          callback = force_active_visual,
          group = group,
        })
      end,
    },
  },
}
