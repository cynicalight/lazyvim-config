return {
  {
    "nvimdev/dashboard-nvim",
    -- 使用函数形式，这样可以获取到 LazyVim 的默认配置(opts)，并在其基础上修改
    opts = function(_, opts)
      local logo = [[
  ██▓    ▄▄▄      ▒███████▒▓██   ██▓
 ▓██▒   ▒████▄    ▒ ▒ ▒ ▄▀░ ▒██  ██▒
 ▒██░   ▒██  ▀█▄  ░ ▒ ▄▀▒░   ▒██ ██░
 ▒██░   ░██▄▄▄▄██   ▄▀▒   ░  ░ ▐██▓░
 ░██████▒▓█   ▓██▒▒███████▒  ░ ██▒▓░
 ░ ▒░▓  ░▒▒   ▓▒█░░▒▒ ▓░▒░▒   ██▒▒▒ 
 ░ ░ ▒  ░ ▒   ▒▒ ░░░▒ ▒ ░ ▒ ▓██ ░▒░ 
   ░ ░    ░   ▒   ░ ░ ░ ░ ░ ▒ ▒ ░░  
     ░  ░     ░  ░  ░ ░     ░ ░     
                  ░         ░ ░     
      ]]

      -- 2. 处理 Logo 的格式
      -- string.rep("\n", 8) 是为了让 Logo 在屏幕垂直方向上居中（顶部留白）
      -- "\n\n" 是为了让 Logo 和下方的按键菜单保持距离
      logo = string.rep("\n", 8) .. logo .. "\n"

      -- 3. 覆盖默认的 header
      -- Dashboard 插件要求 header 是一个 table (列表)，所以要用 vim.split 切割
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
