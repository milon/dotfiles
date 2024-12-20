-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font {
    family = "JetBrainsMono Nerd Font Mono",
    -- harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
}
config.font_size = 16
config.line_height = 1.4

config.window_background_opacity = 0.9
config.macos_window_background_blur = 1

config.color_scheme = "Catppuccin Mocha"
config.colors = wezterm.color.get_builtin_schemes()[config.color_scheme]

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.integrated_title_button_style = "MacOsNative"
config.integrated_title_button_alignment = "Left"
config.native_macos_fullscreen_mode = true
config.default_cursor_style = "BlinkingBar"

config.scrollback_lines = 3000

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false


return config
