return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          -- 重点在这里：强制添加 --config 参数指向你的家目录文件
          args = {
            "--config",
            vim.fn.expand("~/.markdownlint-cli2.jsonc"),
            "--",
          },
        },
      },
    },
  },
}
