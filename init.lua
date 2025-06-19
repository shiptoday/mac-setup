--- Reloads Hammerspoon configuration if a .lua file in ~/.hammerspoon/ is changed.
-- @param files A table of file paths that changed.
local function reloadConfig(files)
    local doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
            break -- Found a Lua file, no need to check further
        end
    end
    if doReload then
        hs.reload()
    end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Global: press the macOS play/pause media key
function mediaPlayPause()
    local ev = hs.eventtap.event
    ev.newSystemKeyEvent("PLAY", true):post()
    ev.newSystemKeyEvent("PLAY", false):post()
  end
  

hs.loadSpoon("Hammerflow") -- Loads the Hammerflow Spoon from ~/.hammerspoon/Spoons/

-- Point Hammerflow at your TOML configuration file(s).
-- Hammerflow will load the first valid (existing) file found in this list.
spoon.Hammerflow.loadFirstValidTomlFile({
    "work.toml" -- Expected at ~/.hammerspoon/work.toml
    -- Add other .toml file names here if needed, e.g., "personal.toml"
})

-- Optional: Auto-reload Hammerspoon and Hammerflow configuration when TOML or Spoon files change.
-- This requires the "ReloadConfiguration" Spoon to be installed.
if spoon.Hammerflow.auto_reload then
    hs.loadSpoon("ReloadConfiguration")
    -- By default, ReloadConfiguration watches hs.configDir (e.g., ~/.hammerspoon/).
    -- To watch additional directories, you can uncomment and modify the following line:
    -- spoon.ReloadConfiguration.watch_paths = {hs.configDir, "/path/to/other/configs"}
    if spoon.ReloadConfiguration then
        spoon.ReloadConfiguration:start()
        hs.alert.show("Hammerflow Auto-Reload Enabled", 0.5)
    else
        hs.alert.show("Hammerflow: ReloadConfiguration Spoon not found for auto_reload.", 2)
    end
end
-- #endregion

-- Ensure all startup messages are potentially visible
hs.notify.show("Hammerspoon", "Configuration fully processed.", "")
