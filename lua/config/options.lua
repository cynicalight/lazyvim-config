-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/bin/python"
-- Soft wrap: long lines don't overflow the screen
vim.opt.wrap = true

-- Wrap at "word boundaries" when possible (for prose/markdown)
vim.opt.linebreak = true

-- Indent wrapped lines to match indentation of the original line
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,min:20"

-- Show a symbol at the start of wrapped screen lines (purely visual)
vim.opt.showbreak = "↪ "

vim.opt.scrolloff = 10

-- for cpp indentation
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true -- Use spaces instead of tabs

vim.g.autoformat = false
