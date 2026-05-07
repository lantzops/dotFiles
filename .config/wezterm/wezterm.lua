-- ~/.config/wezterm/wezterm.lua

-- Import the wezterm API
local wezterm = require 'wezterm'

-- Create a table for the configuration
local config = wezterm.config_builder()

-- =======================================================
-- 1. Appearance and Color (Catppuccin Mocha)
-- =======================================================

-- Catppuccin Mocha is a built-in scheme in WezTerm
config.color_scheme = 'Catppuccin Mocha'

-- Optional: Use the fancy tab bar style for a modern look
config.use_fancy_tab_bar = true

-- =======================================================
-- 2. FINAL CORRECTED Font Settings (JetBrains Mono Bold, Size 14)
-- =======================================================

-- Correct structure: wezterm.font("Name", { style_table }, { features_array })
config.font = wezterm.font(
    '0xProtoNerdFontMono', 
    { 
        weight = 'Bold', 
    }
)

config.font_size = 14.0

-- =======================================================
-- 3. Background Blur Configuration
-- =======================================================

config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- =======================================================
-- 4. Keybindings for Full-Stack Development (Splits)
-- =======================================================
-- This section overrides or extends the default key bindings.
config.keys = {
  -- Horizontal Split: SHIFT + ALT + H
  {
    key = 'h',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },
  
  -- Vertical Split: SHIFT + ALT + V
  {
    key = 'v',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },
}

-- =======================================================
-- 5. Full-Stack Developer QOL/Reddit Recommendations
-- =======================================================

-- Set the default working directory to your home directory
config.default_cwd = wezterm.home_dir

-- Use an event handler to set descriptive tab titles 
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  -- Display the current command or directory for easy identification
  return pane:get_title() or tab.title
end)


-- Finally, return the configuration table to WezTerm
return config
