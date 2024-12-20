local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end

config.default_prog = { '/usr/bin/zsh' }

-- Use wayland, boomer
config.enable_wayland = false

-- Settings
config.color_scheme = 'Atom'
config.font = wezterm.font_with_fallback({
    { family = "Iosevka Nerd Font",        scale = 1.2, weight = "Medium", },
    { family = "FantasqueSansM Nerd Font", scale = 1.3, },
})
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- Send C-a when pressing C-a twice
    { key = "a",          mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },
    { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
    { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },

    -- Pane keybindings
    { key = "s",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "h",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
    { key = "j",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
    { key = "k",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
    { key = "l",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
    { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
    { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
    { key = "o",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },

    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
}

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}

return config
