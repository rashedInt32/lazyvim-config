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

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    suffix = function(diagnostic)
      if diagnostic.code then
        return string.format(" [%s]", diagnostic.code), "DiagnosticFloatingSuffix"
      end
      return "", ""
    end,
    format = function(diagnostic)
      local ok, formatter = pcall(require, "format-ts-errors")
      if ok and diagnostic.code then
        local format_func = formatter[diagnostic.code]
        if format_func and type(format_func) == "function" then
          local formatted_message = format_func(diagnostic.message)
          if formatted_message and formatted_message ~= "" then
            return formatted_message
          end
        end
      end
      return diagnostic.message
    end,
  },
  virtual_text = false,
  signs = true,
  underline = true,
})
