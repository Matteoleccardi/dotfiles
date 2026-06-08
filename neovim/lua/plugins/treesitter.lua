return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- CHANGED: 'config' instead of 'configs' to match modern nvim-treesitter
    require("nvim-treesitter.config").setup({
      ensure_installed = { "python", "cpp", "javascript", "typescript", "markdown", "latex", "lua", "bash" },
      highlight = { enable = true },
    })
  end,
}
