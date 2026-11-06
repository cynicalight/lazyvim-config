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

-- Locally nvim auto-detects pbcopy/pbpaste.
-- Over SSH: copy via OSC 52 (to the local system clipboard), but paste from
-- an in-memory cache. OSC 52 *paste* needs the terminal to answer a clipboard
-- read, which Rex doesn't do → "Timed out waiting for a clipboard response".
-- To paste text copied outside nvim over SSH, use Cmd+V.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  local cache = { ["+"] = { { "" }, "v" }, ["*"] = { { "" }, "v" } }
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      cache[reg] = { lines, regtype }
      send(lines, regtype)
    end
  end
  local function paste(reg)
    return function()
      return cache[reg]
    end
  end
  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
  }
end
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
