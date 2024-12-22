vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.hlsearch = false

local map = vim.keymap.set

-- Doom emacs save file
map("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Ctrl-g to escape
map({ "i", "x", "n", "s", "o", "c" }, "<C-g>", "<Esc>")

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>ws", "<C-W>s<cr><C-W>k", { desc = "Split window below", remap = true })
map("n", "<leader>wS", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wv", "<C-W>v<cr><C-W>h", { desc = "Split window right", remap = true })
map("n", "<leader>wV", "<C-W>v", { desc = "Split window right", remap = true })

-- buffers
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bk", "<cmd>bd<cr>", { desc = "Kill Buffer" })

-- maximize
map("n", "<leader>wmm", "<C-W>_<cr><C-W>|", { desc = "Maximize window", remap = true })

-- Doom emacs window navigation
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window", remap = true })
-- resizing
map("n", "<leader>w<C-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<leader>w<C-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<leader>w<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<leader>w<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- magit
map("n", "<leader>gg", "<cmd>! magit<cr>", { desc = "Magit" })

-- Map Alt-x to jump to the command line
map("n", "<M-x>", ":", { noremap = true, silent = false })

-- hot reload current lua file
map("n", "<leader>hrr", "<cmd>luafile %<cr>", { noremap = true, silent = true })

-- quit
map("n", "<leader>qQ", "<cmd>qa<cr>", { noremap = true, silent = true })
map("n", "<leader>qq", "<cmd>q<cr>", { noremap = true, silent = true })
map("n", "<leader>qF", "<cmd>qa!<cr>", { noremap = true, silent = true })
