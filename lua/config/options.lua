-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniconda/base/bin/python"

local magickConfigDir = vim.fn.expand("~/.config/imagemagick")
local homebrewMagickConfigDir = "/opt/homebrew/etc/ImageMagick-7"
local currentMagickConfigPath = vim.env.MAGICK_CONFIGURE_PATH

if currentMagickConfigPath and currentMagickConfigPath ~= "" then
  vim.env.MAGICK_CONFIGURE_PATH = table.concat({ magickConfigDir, homebrewMagickConfigDir, currentMagickConfigPath }, ":")
else
  vim.env.MAGICK_CONFIGURE_PATH = table.concat({ magickConfigDir, homebrewMagickConfigDir }, ":")
end
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

-- global indentation defaults
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.g.autoformat = false

vim.g.clipboard = "osc52"
vim.opt.clipboard = "unnamedplus"
