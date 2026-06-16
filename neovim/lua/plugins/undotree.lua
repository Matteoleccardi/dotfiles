-- Show left-pane with undo history, you can navigate it and go back in file versions, with branching

return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
  },
  config = function()
    -- Optional: Persist undo history between sessions
    vim.opt.undofile = true
  end,
}

