return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      window = {
        width = 0.3,
      },
      headers = {
        user = "JZ",
      },
    },
    keys = {
      {
        "<leader>at",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      },
    },
  },
}
