vim.g.python3_host_prog = "/usr/bin/python3"
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
-- Include TypeScript variables in the LSP symbol picker.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local symbol_kinds = vim.deepcopy(LazyVim.config.kind_filter.default)
    vim.list_extend(symbol_kinds, { "Variable", "Constant" })
    LazyVim.config.kind_filter.typescript = symbol_kinds
    LazyVim.config.kind_filter.typescriptreact = vim.deepcopy(symbol_kinds)
  end,
})
