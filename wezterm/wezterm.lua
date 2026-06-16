local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Tell applications to use advanced WezTerm features instead of generic xterm
-- config.term = 'wezterm' --(probably default, not working so i commented tis out)

-- Colors (Fully renders Catppuccin in 24-bit true color)
config.color_scheme = 'Catppuccin Mocha'

-- Font Configuration
config.font = wezterm.font({
  family = 'FiraMono Nerd Font Mono Medium',
  weight = 'Regular',
})
config.font_size = 10.0

-- Window Dimensions
config.initial_cols = 120
config.initial_rows = 30

-- Window Padding
config.window_padding = {
  left = 2, right = 2, top = 2, bottom = 2,
}

config.enable_tab_bar = false

return config

