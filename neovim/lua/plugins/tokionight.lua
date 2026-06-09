-- color and style scheme
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- Load immediately during startup
  priority = 1000, -- Load this before all other plugins
  opts = {
    styles = {
      -- Enable italics for comments
      comments = { italic = true },
      -- You can also enable italics for keywords or functions if desired:
      keywords = { italic = false },
    },
  },
  config = function(_, opts)
    -- Pass the options block above to the setup function
    require("tokyonight").setup(opts)
    
    -- Set your preferred flavor: tokyonight, tokyonight-storm, tokyonight-moon, or tokyonight-day
    vim.cmd([[colorscheme tokyonight-storm]])
  end,
}
