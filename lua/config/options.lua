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

-- 1. Custom signs (gutter icons)
local signs = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = "󰌵 ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 2. Configure diagnostics
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  signs = true,
  virtual_text = false,
  underline = true,

  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",

    -- Suffix code display w/ subtle italic
    suffix = function(diagnostic)
      if diagnostic.code then
        return string.format(" [%s]", diagnostic.code), "DiagnosticHintItalic"
      end
      return "", ""
    end,

    format = function(diagnostic)
      -- Severity-colored icon mapping
      local icon_map = {
        [vim.diagnostic.severity.ERROR] = { " ", "DiagnosticError" },
        [vim.diagnostic.severity.WARN] = { " ", "DiagnosticWarn" },
        [vim.diagnostic.severity.INFO] = { " ", "DiagnosticInfo" },
        [vim.diagnostic.severity.HINT] = { "󰌵 ", "DiagnosticHint" },
      }

      local icon, hl = unpack(icon_map[diagnostic.severity] or { "", "" })
      local icon_str = (hl ~= "" and ("%#" .. hl .. "#" .. icon .. "%*") or icon)

      -- TypeScript-specific formatting fallback
      local ok, formatter = pcall(require, "format-ts-errors")
      if ok and diagnostic.code then
        local format_func = formatter[diagnostic.code]
        if format_func and type(format_func) == "function" then
          local msg = format_func(diagnostic.message)
          if msg and msg ~= "" then
            msg = msg:gsub("```typescript\n", ""):gsub("```ts\n", ""):gsub("\n```", "")
            return icon_str .. msg
          end
        end
      end

      return icon_str .. diagnostic.message
    end,
  },
})

-- 3. Add highlight for subtle italic suffix (C2)
vim.api.nvim_set_hl(0, "DiagnosticHintItalic", { link = "DiagnosticHint", italic = true })
