local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'AdventureTime'
config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
config.font = wezterm.font 'SF Mono'
config.font_size = 13.5
-- Make the app fill entire MacBook Pro monitor on start
config.initial_rows = 53
config.initial_cols = 172
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = 'LeftArrow', mods='OPT', action=wezterm.action{ SendString = '\x1bb' } },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = 'RightArrow', mods='OPT', action=wezterm.action { SendString='\x1bf' } },
}
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
  left = '2cell',
  right = '2cell',
}

return config
