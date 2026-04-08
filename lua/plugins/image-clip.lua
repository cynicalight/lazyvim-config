return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
  },
  keys = {
    {
      "<leader>h",
      function() require("cos-upload").paste_and_upload() end,
      desc = "Paste image & upload to COS",
    },
  },
}
