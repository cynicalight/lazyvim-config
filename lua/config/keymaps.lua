-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 强制 <leader>ft 打开浮动终端 (基于 Snacks.terminal)
vim.keymap.set("n", "<leader>ft", function()
  -- win = { style = "float" } 是默认值，这里显式写出来以防万一
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = { style = "float" } })
end, { desc = "Terminal (Root Dir)" })

vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- 将当前行的错误信息复制到系统剪贴板
vim.keymap.set("n", "<leader>ce", function()
  -- 获取当前行的所有诊断信息
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diagnostics > 0 then
    -- 取第一个报错信息
    local message = diagnostics[1].message
    -- 写入系统剪贴板 (+)
    vim.fn.setreg("+", message)
    print("📋 报错已复制: " .. message)
  else
    print("✅ 当前行没有报错")
  end
end, { desc = "Copy Error to Clipboard" })

vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
-- 2. 🛡️ 核心步骤：彻底删除旧的 <leader>bp 映射
-- 使用 pcall 避免报错，删掉它，给 DAP 腾出位置
vim.keymap.set("n", "<leader>bp", function()
  -- 使用 pcall 防止插件没装时报错，虽然肯定装了
  local ok, xcodebuild = pcall(require, "xcodebuild.integrations.dap")
  if ok then
    xcodebuild.toggle_breakpoint()
  else
    vim.notify("Xcodebuild 插件未加载", vim.log.levels.ERROR)
  end
end, { desc = "Toggle Breakpoint" })

-- buffer move
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineMoveNext<cr>")
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineMovePrev<cr>")
