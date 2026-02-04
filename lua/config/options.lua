-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- line number and relative line number
vim.opt.number = false
vim.opt.relativenumber = false

--vim.opt.colorcolumn = "80"
--
vim.filetype.add({
  extension = {
    ["blade.php"] = "blade",
  },
})

vim.opt.guicursor = {
  "n-v-c:block", -- Normal mode: block
  "i-ci-ve:ver25", -- Insert mode: vertical bar
  "r-cr:hor20", -- Replace mode: horizontal
  "o:hor50", -- Operator pending
}

-- Override tab width for Go files (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- Go generally uses tabs, not spaces
  end,
})

-- ===========================================
-- Neovide Configuration (matched with Ghostty)
-- ===========================================
if vim.g.neovide then
  -- Font (matching Ghostty: font-family = "JetBrains Mono Nerd Font", font-size=21)
  -- Note: Actual font name is "JetBrainsMono Nerd Font" (no space between JetBrains and Mono)
  vim.o.guifont = "JetBrainsMono Nerd Font:h21"

  -- Transparency (matching Ghostty: background-opacity = 1.0)
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 1.0

  -- Window blur (macOS)
  vim.g.neovide_window_blurred = true

  -- Floating window effects
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Cursor settings (matching Ghostty: cursor-style-blink = false)
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_smooth_blink = false

  -- Cursor particle effects (set to "" for none, or "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe")
  vim.g.neovide_cursor_vfx_mode = ""

  -- Scroll animation
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_scroll_animation_far_lines = 1

  -- Hide mouse when typing (matching Ghostty: mouse-hide-while-typing = true)
  vim.g.neovide_hide_mouse_when_typing = true

  -- Refresh rate (matching Ghostty: window-vsync = false)
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = false

  -- Theme (auto follows system)
  vim.g.neovide_theme = "auto"

  -- Remember window size
  vim.g.neovide_remember_window_size = true

  -- Confirm quit with unsaved changes
  vim.g.neovide_confirm_quit = true

  -- Padding (matching Ghostty: window-padding-x = 0, window-padding-y = 0)
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  -- macOS specific: Option key as Meta
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end
