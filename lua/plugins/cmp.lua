return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- 使用 'super-tab' 预设
        -- 效果：
        -- Tab: 接受补全 / 选择下一个
        -- Shift+Tab: 选择上一个
        -- Enter: 仅仅是换行 (不接受补全)
        preset = "super-tab",

        -- 如果你觉得 super-tab 的默认逻辑不顺手，
        -- 也可以手动通过 cmd 指定，例如：
        -- ["<Tab>"] = { "select_and_accept", "fallback" },
        -- ["<CR>"] = { "fallback" },
      },
    },
  },
}
