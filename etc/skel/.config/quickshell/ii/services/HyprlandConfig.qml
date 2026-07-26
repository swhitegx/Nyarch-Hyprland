pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.modules.common
import qs.modules.common.functions

/**
 * Configures Hyprland — writes hl.config() lines to shellOverrides/main.lua.
 * Values written here persist across restarts and override the defaults.
 */
Singleton {
    id: root
    
    signal reloaded()

    readonly property string configuratorScriptPath: Quickshell.shellPath("scripts/hyprland/hyprconfigurator.py")
    readonly property string shellOverridesPath: FileUtils.trimFileProtocol(`${Directories.config}/hypr/hyprland/shellOverrides/main.lua`)

    // Cache of last-set values so the UI can read them back
    property var lastSetValues: ({})

    function set(key: string, value: var) {
        lastSetValues[key] = value
        Quickshell.execDetached(["bash", "-c", //
            `${root.configuratorScriptPath} --file ${root.shellOverridesPath} --set "${key}" "${value}"` //
        ])
    }
    
    function setMany(entries: var) {
        let args = ""
        for (let key in entries) {
            lastSetValues[key] = entries[key]
            args += `--set "${key}" "${entries[key]}" `
        }
        Quickshell.execDetached(["bash", "-c", //
            `${root.configuratorScriptPath} --file ${root.shellOverridesPath} ${args}` //
        ])
    }
    
    function reset(key: string) {
        delete lastSetValues[key]
        Quickshell.execDetached(["bash", "-c", //
            `${root.configuratorScriptPath} --file ${root.shellOverridesPath} --reset "${key}"` //
        ])
    }
    
    function resetMany(keys: list<string>) {
        for (let i = 0; i < keys.length; i++) {
            delete lastSetValues[keys[i]]
        }
        let args = ""
        for (let i = 0; i < keys.length; i++) {
            args += `--reset "${keys[i]}" `
        }
        Quickshell.execDetached(["bash", "-c", //
            `${root.configuratorScriptPath} --file ${root.shellOverridesPath} ${args}` //
        ])
    }

    /**
     * Get a cached config value.
     * Returns the value last set via HyprlandConfig.set(), or null if unset.
     * For a complete read-back, hyprset reads the config files directly.
     */
    function get(key: string) {
        if (key in lastSetValues)
            return lastSetValues[key]
        return null
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name == "configreloaded") {
                root.reloaded()
            }
        }
    }
}
