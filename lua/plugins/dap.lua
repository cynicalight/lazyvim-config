-- return {
--   "mfussenegger/nvim-dap",
--   dependencies = {
--     "wojciech-kulik/xcodebuild.nvim",
--     "rcarriga/nvim-dap-ui", -- Wiki 提到需要安装这个来获得 nice GUI
--     "nvim-neotest/nvim-nio", -- nvim-dap-ui 的依赖
--   },
--   config = function()
--     local xcodebuild = require("xcodebuild.integrations.dap")
--     local dapui = require("dapui")
--
--     -- 1. 初始化 xcodebuild 的 DAP 集成
--     xcodebuild.setup()
--
--     -- 2. 初始化 UI 界面
--     dapui.setup()
--
--     -- 3. 自动打开/关闭调试界面 (可选但推荐)
--     local dap = require("dap")
--     dap.listeners.after.event_initialized["dapui_config"] = function()
--       dapui.open()
--     end
--     dap.listeners.before.event_terminated["dapui_config"] = function()
--       dapui.close()
--     end
--     dap.listeners.before.event_exited["dapui_config"] = function()
--       dapui.close()
--     end
--
--     -- 4. 快捷键配置 (直接复用 Wiki 提供的配置)
--     vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
--     vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
--     vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
--     vim.keymap.set("n", "<leader>bp", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
--     vim.keymap.set("n", "<leader>bm", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
--     vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
--   end,
-- }

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "wojciech-kulik/xcodebuild.nvim",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  -- 🟢 重点：把所有快捷键移到这里！
  keys = {
    -- 1. 你的核心诉求：<leader>bp = Toggle Breakpoint
    -- Lazy.nvim 会帮你处理这个覆盖
    {
      "<leader>bp",
      function()
        require("xcodebuild.integrations.dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },

    -- 2. 其他快捷键保持队形
    {
      "<leader>bm",
      function()
        require("xcodebuild.integrations.dap").toggle_message_breakpoint()
      end,
      desc = "Toggle Message Breakpoint",
    },
    {
      "<leader>dd",
      function()
        require("xcodebuild.integrations.dap").build_and_debug()
      end,
      desc = "Build & Debug",
    },
    {
      "<leader>dr",
      function()
        require("xcodebuild.integrations.dap").debug_without_build()
      end,
      desc = "Debug Without Building",
    },
    {
      "<leader>dx",
      function()
        require("xcodebuild.integrations.dap").terminate_session()
      end,
      desc = "Terminate Debugger",
    },
  },
  config = function()
    local xcodebuild = require("xcodebuild.integrations.dap")
    local dapui = require("dapui")

    xcodebuild.setup()
    dapui.setup()

    -- ⚠️ 注意：这里不需要再写 vim.keymap.set 了！上面 keys 已经搞定了。

    -- 自动 UI 逻辑保留
    local dap = require("dap")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
