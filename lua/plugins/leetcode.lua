return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- 确保安装 html parser
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- 你的 Picker 插件，例如 telescope
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    -- 默认编程语言
    lang = "cpp",

    -- 中国区配置 (leetcode.cn)
    cn = {
      enabled = true, -- 开启中国区
      translator = true, --开启翻译
      translate_problems = true, -- 翻译题目描述
    },

    -- 存储路径配置
    storage = {
      home = vim.fn.stdpath("data") .. "/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    -- 插件集成
    plugins = {
      non_standalone = false, -- 设置为 true 可在现有 Neovim 会话中通过 :Leet 启动
    },
  },
}
