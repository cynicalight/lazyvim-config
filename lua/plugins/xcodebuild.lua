return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- LazyVim 用户默认已有 snacks 和 treesitter，无需重复声明
  },
  config = function()
    require("xcodebuild").setup({
      show_build_progress_bar = true, -- 显示构建进度条
      logs = {
        auto_open_on_success_tests = false, -- 测试通过不自动弹日志
        auto_open_on_failed_tests = true, -- 测试失败自动弹日志
        auto_open_on_success_build = false,
        auto_open_on_failed_build = true,
      },
    })

    -- 绑定快捷键 (最常用的功能)
    local keymap = vim.keymap.set
    keymap("n", "<leader>z", "", { desc = "Xcodebuild" }) -- 创建一个组前缀
    keymap("n", "<leader>zp", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcode Picker" })
    keymap("n", "<leader>zb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    keymap("n", "<leader>zr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run" })
    keymap("n", "<leader>zt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    keymap("n", "<leader>zd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
  end,
}
