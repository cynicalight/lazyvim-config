return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },

  {
    "sainnhe/gruvbox-material",
    lazy = true, -- 建议也 lazy，别强行抢启动
    init = function()
      -- 必须在加载 colorscheme 前设置的全局变量放 init
      vim.g.gruvbox_material_background = "soft" -- hard | medium | soft
      vim.g.gruvbox_material_foreground = "material" -- material | mix | original
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1

      -- 透明背景开关 ✅
      vim.g.gruvbox_material_transparent_background = 1

      -- 诊断 / LSP
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_signs = 1
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
