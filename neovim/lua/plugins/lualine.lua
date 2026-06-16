-- nice status bar
-- relies on the presence of the catpuccin-mocha theme

return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            options = {
                theme = "catppuccin-mocha",
            }
        })

    end
}
