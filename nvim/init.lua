-------------------------------------------------------
local vim = vim

vim.g.mapleader = ' '
vim.g.colors_name = 'gloombuddy'

local o = vim.o
local b = vim.bo
local w = vim.wo

-- vim.o
o.termguicolors = true
o.syntax = 'on'
o.errorbells = false
o.smartcase = true
o.showmode = false
o.backup = false
o.undodir = vim.fn.stdpath('config') .. '/undodir'
o.undofile = true
o.incsearch = true
o.hidden = true
o.completeopt='menuone,noinsert,noselect'
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- vim buffer options
b.swapfile = false
b.autoindent = true
b.smartindent = true

-- vim window options
w.number = true
w.relativenumber = true
w.signcolumn = 'yes'
w.wrap = false

require'aftertale'
