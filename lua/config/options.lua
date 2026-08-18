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
vim.opt.shiftround = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "∘",
}

vim.opt.autoindent = true
vim.opt.preserveindent = true
vim.opt.copyindent = true
vim.opt.formatoptions:remove({ "c", "r", "o", "t" })
vim.opt.textwidth = 0
vim.opt.indentexpr = ""

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

vim.g.autoformat = true

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(args)
    local buf = args.buf
    local path = vim.api.nvim_buf_get_name(buf)
    local excluded = {
      vim.fn.expand("~/Documents/codes/happydance/Base"),
      vim.fn.expand("~/Documents/codes/happydance/regeneron-careers-frontend"),
    }
    if vim.iter(excluded):any(function(p) return path:find(p, 1, true) end) then
      vim.b[buf].autoformat = false
    end
  end,
})

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
    vim.opt_local.expandtab = false
  end,
})

-- Auto-detect indentation style per project
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "json",
    "python",
    "ruby",
    "lua",
  },
  callback = function(args)
    local buf = args.buf
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local lines = vim.api.nvim_buf_get_lines(buf, 0, 100, false)
      local tab_count = 0
      local space_count = 0

      for _, line in ipairs(lines) do
        if line:match("^\t") then
          tab_count = tab_count + 1
        elseif line:match("^  ") then
          space_count = space_count + 1
        end
      end

      if tab_count > space_count then
        vim.bo[buf].expandtab = false
        vim.bo[buf].tabstop = 2
        vim.bo[buf].softtabstop = 2
        vim.bo[buf].shiftwidth = 2
      else
        vim.bo[buf].expandtab = true
        vim.bo[buf].tabstop = 2
        vim.bo[buf].softtabstop = 2
        vim.bo[buf].shiftwidth = 2
      end
    end)
  end,
})

-- Recover the treesitter highlighter when a large change kills it (undo after a
-- big format used to do this).
--
-- This used to stop *and* restart treesitter on every TextChanged, in every
-- buffer, which forced a full reparse per edit and fought LazyVim's own
-- vim.treesitter.start on FileType. Only act once the highlighter has actually
-- gone away, and only for buffers that had one, so nothing gets treesitter
-- turned on behind LazyVim's back.
local ts_highlighted = {}

vim.api.nvim_create_autocmd("TextChanged", {
  desc = "Restart the treesitter highlighter only if a change killed it",
  callback = function(args)
    local buf = args.buf
    if vim.treesitter.highlighter.active[buf] then
      ts_highlighted[buf] = true
    elseif ts_highlighted[buf] and not pcall(vim.treesitter.start, buf) then
      ts_highlighted[buf] = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  desc = "Forget treesitter highlighter state for gone buffers",
  callback = function(args)
    ts_highlighted[args.buf] = nil
  end,
})
