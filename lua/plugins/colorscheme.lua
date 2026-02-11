return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- 选项: latte, frappe, macchiato, mocha
      transparent_background = true, -- 是否透明背景
    },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false, -- 主题必须立刻加载
    priority = 1000, -- 比其他插件先加载
    config = function()
      -- 核心风格设置（在 set colorscheme 之前）
      -- vim.o.background = "light"
      vim.g.gruvbox_material_background = "soft" -- hard | medium | soft
      vim.g.gruvbox_material_foreground = "material" -- material | mix | original
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1

      -- 诊断 / LSP 更清晰（强烈建议）
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_signs = 1

      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
