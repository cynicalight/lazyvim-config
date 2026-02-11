-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)

-- 1. 开启自动读取外部变更
vim.o.autoread = true

-- 2. 只有当光标聚焦或停留时，才触发检查（避免性能损耗）
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    -- 如果当前不在命令行模式，则检查文件变更
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- 3. 如果文件被改变了但 buffer 没变，静默重新加载，不要报错
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  command = "echom 'File changed on disk. Buffer reloaded.'",
})
