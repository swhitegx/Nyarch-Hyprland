import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "keyboard"
        title: Translation.tr("Keyboard")
        ConfigRow {
            uniform: true
            ConfigSpinBox {
                icon: "keyboard"
                text: Translation.tr("Repeat delay (ms)")
                value: parseInt(HyprlandConfig.get("input:repeat_delay") ?? 250)
                from: 100; to: 1000; stepSize: 10
                onValueChanged: HyprlandConfig.set("input:repeat_delay", value)
            }
            ConfigSpinBox {
                icon: "repeat"
                text: Translation.tr("Repeat rate (chars/s)")
                value: parseInt(HyprlandConfig.get("input:repeat_rate") ?? 35)
                from: 10; to: 100; stepSize: 5
                onValueChanged: HyprlandConfig.set("input:repeat_rate", value)
            }
        }
        ConfigSwitch {
            buttonIcon: "keyboard"
            text: Translation.tr("Numlock by default")
            checked: HyprlandConfig.get("input:numlock_by_default") === "true"
            onCheckedChanged: HyprlandConfig.set("input:numlock_by_default", checked ? "true" : "false")
        }
    }

    ContentSection {
        icon: "mouse"
        title: Translation.tr("Mouse")
        ConfigRow {
            uniform: true
            ConfigSpinBox {
                icon: "mouse"
                text: Translation.tr("Sensitivity")
                value: parseFloat(HyprlandConfig.get("input:sensitivity") ?? 0)
                from: -1; to: 1; stepSize: 0.1
                onValueChanged: HyprlandConfig.set("input:sensitivity", value.toFixed(1))
            }
            ConfigSpinBox {
                icon: "nearby"
                text: Translation.tr("Accel profile")
                value: parseInt(HyprlandConfig.get("input:accel_profile") ?? 0)
                from: 0; to: 2; stepSize: 1
                onValueChanged: HyprlandConfig.set("input:accel_profile", value)
            }
        }
        ConfigSpinBox {
            icon: "scroll"
            text: Translation.tr("Scroll factor")
            value: parseFloat(HyprlandConfig.get("input:scroll_factor") ?? 1.0)
            from: 0.1; to: 5; stepSize: 0.1
            onValueChanged: HyprlandConfig.set("input:scroll_factor", value.toFixed(1))
        }
    }

    ContentSection {
        icon: "laptop"
        title: Translation.tr("Touchpad")
        ConfigSwitch {
            buttonIcon: "natural_comp"
            text: Translation.tr("Natural scroll")
            checked: HyprlandConfig.get("input:touchpad:natural_scroll") === "true"
            onCheckedChanged: HyprlandConfig.set("input:touchpad:natural_scroll", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "disable"
            text: Translation.tr("Disable while typing")
            checked: HyprlandConfig.get("input:touchpad:disable_while_typing") !== "false"
            onCheckedChanged: HyprlandConfig.set("input:touchpad:disable_while_typing", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "touch_app"
            text: Translation.tr("Clickfinger behavior")
            checked: HyprlandConfig.get("input:touchpad:clickfinger_behavior") === "true"
            onCheckedChanged: HyprlandConfig.set("input:touchpad:clickfinger_behavior", checked ? "true" : "false")
        }
        ConfigSlider {
            text: Translation.tr("Scroll factor")
            value: parseFloat(HyprlandConfig.get("input:touchpad:scroll_factor") ?? 0.7)
            from: 0.1; to: 3; stepSize: 0.1
            onValueChanged: HyprlandConfig.set("input:touchpad:scroll_factor", value.toFixed(1))
        }
    }

    ContentSection {
        icon: "gesture"
        title: Translation.tr("Gestures")
        ConfigSpinBox {
            icon: "swipe"
            text: Translation.tr("Workspace swipe distance")
            value: parseInt(HyprlandConfig.get("gestures:workspace_swipe_distance") ?? 700)
            from: 100; to: 2000; stepSize: 50
            onValueChanged: HyprlandConfig.set("gestures:workspace_swipe_distance", value)
        }
        ConfigSlider {
            text: Translation.tr("Swipe cancel ratio")
            value: parseFloat(HyprlandConfig.get("gestures:workspace_swipe_cancel_ratio") ?? 0.2)
            from: 0; to: 1; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("gestures:workspace_swipe_cancel_ratio", value.toFixed(2))
        }
        ConfigSpinBox {
            icon: "speed"
            text: Translation.tr("Min speed to force")
            value: parseInt(HyprlandConfig.get("gestures:workspace_swipe_min_speed_to_force") ?? 5)
            from: 1; to: 30; stepSize: 1
            onValueChanged: HyprlandConfig.set("gestures:workspace_swipe_min_speed_to_force", value)
        }
        ConfigSwitch {
            buttonIcon: "lock"
            text: Translation.tr("Direction lock")
            checked: HyprlandConfig.get("gestures:workspace_swipe_direction_lock") === "true"
            onCheckedChanged: HyprlandConfig.set("gestures:workspace_swipe_direction_lock", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "add"
            text: Translation.tr("Create new workspace on swipe")
            checked: HyprlandConfig.get("gestures:workspace_swipe_create_new") === "true"
            onCheckedChanged: HyprlandConfig.set("gestures:workspace_swipe_create_new", checked ? "true" : "false")
        }
    }
}
