-- A fuzzy finder
-- It allows you to quickly search for, preview, and select files, text strings, commands, 
-- and git history without leaving your code editor.

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Project Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search Words in Project" },
  },
}
