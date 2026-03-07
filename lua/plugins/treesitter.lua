return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy", -- 保持你原来的设置
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query", -- 默认的一些
      "html", -- <--- 在这里添加 html
      "cpp",
      "python",
      "go",
    },
    -- ... 其他配置
  },
}
