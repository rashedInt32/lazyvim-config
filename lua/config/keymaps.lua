-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-y>", "<C-r>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "E", "$")
vim.keymap.set("v", "B", "^")
vim.keymap.set("n", "E", "$") -- end of line
vim.keymap.set("n", "B", "^") -- beginning of line (non-whitespace)

-- some comment
-- Another comment

-- safe delete and change
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true })
vim.keymap.set("n", "<leader>c", '"_c', { noremap = true })
vim.keymap.set("x", "<leader>d", '"_d', { noremap = true })
vim.keymap.set("x", "<leader>c", '"_c', { noremap = true })

-- Unmap <leader>l to prevent Lazy popup from interfering with <leader>ld
-- Remap Lazy to <leader>L instead
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Map <leader>ld to open Trouble with diagnostics
vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

-- Delete end of the line while insert mode
vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Delete to end of line" })

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.keymap.set("n", "<leader>fs", function()
  local path = os.getenv("HOME") .. "/.config/.local/scripts/tmux-sessionizer"
  local in_tmux = os.getenv("TMUX")

  if in_tmux then
    -- Already in a tmux session: just open a new window
    vim.fn.system('tmux new-window -n sessionizer "' .. path .. '"')
  else
    -- Not in tmux: start a new session and run the script
    -- This opens a terminal and runs tmux directly
    vim.fn.jobstart({ "tmux", "new-session", path }, {
      detach = true,
    })
    print("Started tmux with sessionizer")
  end
end, { desc = "Launch tmux-sessionizer" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- vim.keymap.set("n", "<C-n>", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<C-p>", ":bprev<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

--de This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- saving files
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file with <C-w>", noremap = true, silent = true })

--vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

vim.keymap.set("n", "<leader>ca", function()
  require("cellular-automaton").start_animation("make_it_rain")
end)

vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  require("gitsigns").next_hunk()
  return "<Ignore>"
end, { expr = true })

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  require("gitsigns").prev_hunk()
  return "<Ignore>"
end, { expr = true })

vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>")

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Show signature help" })
-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)
