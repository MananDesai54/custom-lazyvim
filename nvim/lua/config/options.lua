-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Keep diff views readable and keyboard-focused
opt.mouse = "a" -- enable mouse support in all modes when needed
opt.signcolumn = "yes:2"
opt.scrolloff = 5
opt.wrap = true
opt.linebreak = true
opt.number = true
opt.relativenumber = false
opt.diffopt:append({ "linematch:60", "algorithm:histogram" })
opt.fillchars:append({ diff = "╱" })
