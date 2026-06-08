return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Project Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search Words in Project" },
  },
}
