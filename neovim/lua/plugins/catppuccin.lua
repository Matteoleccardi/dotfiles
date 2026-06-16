-- color and style scheme
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- use the mocha flavor -- https://github.com/catppuccin/catppuccin
        integations = {
            lualine = true,
        }
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  }
}
