import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "speed"
        title: Translation.tr("Variable Refresh Rate")
        ConfigSelectionArray {
            currentValue: (HyprlandConfig.get("misc:vrr") ?? "0").toString()
            onSelected: newValue => HyprlandConfig.set("misc:vrr", newValue)
            options: [
                { icon: "close", value: "0", displayName: Translation.tr("Off") },
                { icon: "check", value: "1", displayName: Translation.tr("On") },
                { icon: "auto", value: "2", displayName: Translation.tr("Fullscreen only") },
            ]
        }
    }

    ContentSection {
        icon: "animation"
        title: Translation.tr("Animations")
        ConfigSwitch {
            buttonIcon: "animation"
            text: Translation.tr("Enable animations")
            checked: HyprlandConfig.get("animations:enabled") !== "false"
            onCheckedChanged: HyprlandConfig.set("animations:enabled", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "move"
            text: Translation.tr("Animate manual resizes")
            checked: HyprlandConfig.get("misc:animate_manual_resizes") === "true"
            onCheckedChanged: HyprlandConfig.set("misc:animate_manual_resizes", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "open_with"
            text: Translation.tr("Animate mouse window dragging")
            checked: HyprlandConfig.get("misc:animate_mouse_windowdragging") === "true"
            onCheckedChanged: HyprlandConfig.set("misc:animate_mouse_windowdragging", checked ? "true" : "false")
        }
    }

    ContentSection {
        icon: "swipe"
        title: Translation.tr("Window swallowing")
        ConfigSwitch {
            buttonIcon: "swipe"
            text: Translation.tr("Enable swallow")
            checked: HyprlandConfig.get("misc:enable_swallow") === "true"
            onCheckedChanged: HyprlandConfig.set("misc:enable_swallow", checked ? "true" : "false")
        }
    }

    ContentSection {
        icon: "apps"
        title: Translation.tr("XWayland")
        ConfigSwitch {
            buttonIcon: "apps"
            text: Translation.tr("Force zero scaling")
            checked: HyprlandConfig.get("xwayland:force_zero_scaling") === "true"
            onCheckedChanged: HyprlandConfig.set("xwayland:force_zero_scaling", checked ? "true" : "false")
        }
    }

    ContentSection {
        icon: "power"
        title: Translation.tr("Display power management")
        ConfigSwitch {
            buttonIcon: "power"
            text: Translation.tr("Mouse move wakes display")
            checked: HyprlandConfig.get("misc:mouse_move_enables_dpms") !== "false"
            onCheckedChanged: HyprlandConfig.set("misc:mouse_move_enables_dpms", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "keyboard"
            text: Translation.tr("Key press wakes display")
            checked: HyprlandConfig.get("misc:key_press_enables_dpms") !== "false"
            onCheckedChanged: HyprlandConfig.set("misc:key_press_enables_dpms", checked ? "true" : "false")
        }
    }

    ContentSection {
        icon: "settings"
        title: Translation.tr("Other")
        ConfigSwitch {
            buttonIcon: "logo"
            text: Translation.tr("Show Hyprland logo")
            checked: HyprlandConfig.get("misc:disable_hyprland_logo") !== "true"
            onCheckedChanged: HyprlandConfig.set("misc:disable_hyprland_logo", checked ? "false" : "true")
        }
        ConfigSwitch {
            buttonIcon: "animation"
            text: Translation.tr("Disable splash rendering")
            checked: HyprlandConfig.get("misc:disable_splash_rendering") === "true"
            onCheckedChanged: HyprlandConfig.set("misc:disable_splash_rendering", checked ? "true" : "false")
        }
    }
}
