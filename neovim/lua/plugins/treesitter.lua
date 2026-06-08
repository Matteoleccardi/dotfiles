return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "cpp", "javascript", "typescript", "markdown", "latex", "lua" },
      highlight = { enable = true },
    })
  end,
}
