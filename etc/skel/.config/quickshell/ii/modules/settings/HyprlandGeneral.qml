import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    // ── Gaps ──
    ContentSection {
        icon: "grid_view"
        title: Translation.tr("Gaps")

        ConfigSpinBox {
            icon: "view_compact"
            text: Translation.tr("Gaps In")
            tooltip: Translation.tr("Gaps between windows in pixels")
            value: HyprlandConfig.get("general:gaps_in") ?? 4
            from: 0; to: 50; stepSize: 1
            onValueChanged: HyprlandConfig.set("general:gaps_in", value)
        }
        ConfigSpinBox {
            icon: "space_bar"
            text: Translation.tr("Gaps Out")
            tooltip: Translation.tr("Gaps between windows and screen edges")
            value: HyprlandConfig.get("general:gaps_out") ?? 5
            from: 0; to: 100; stepSize: 1
            onValueChanged: HyprlandConfig.set("general:gaps_out", value)
        }
        ConfigSpinBox {
            icon: "stacks"
            text: Translation.tr("Gaps Workspaces")
            tooltip: Translation.tr("Extra gaps between workspaces, stacks with gaps_out")
            value: HyprlandConfig.get("general:gaps_workspaces") ?? 50
            from: 0; to: 200; stepSize: 5
            onValueChanged: HyprlandConfig.set("general:gaps_workspaces", value)
        }
    }

    // ── Borders ──
    ContentSection {
        icon: "border_style"
        title: Translation.tr("Borders")

        ConfigSpinBox {
            icon: "border_all"
            text: Translation.tr("Border Size")
            tooltip: Translation.tr("Width of window borders in pixels")
            value: HyprlandConfig.get("general:border_size") ?? 1
            from: 0; to: 20; stepSize: 1
            onValueChanged: HyprlandConfig.set("general:border_size", value)
        }
        ConfigSwitch {
            buttonIcon: "border_clear"
            text: Translation.tr("No border on floating")
            checked: HyprlandConfig.get("general:no_border_on_floating") === "true"
            onCheckedChanged: HyprlandConfig.set("general:no_border_on_floating", checked ? "true" : "false")
        }
        ConfigSwitch {
            buttonIcon: "open_with"
            text: Translation.tr("Resize on border")
            tooltip: Translation.tr("Click and drag on borders to resize windows")
            checked: HyprlandConfig.get("general:resize_on_border") === "true"
            onCheckedChanged: HyprlandConfig.set("general:resize_on_border", checked ? "true" : "false")
        }
    }

    // ── Layout ──
    ContentSection {
        icon: "grid_on"
        title: Translation.tr("Layout")

        ConfigSelectionArray {
            currentValue: HyprlandConfig.get("general:layout") ?? "dwindle"
            onSelected: newValue => HyprlandConfig.set("general:layout", newValue)
            options: [
                { icon: "grid_on", value: "dwindle", displayName: Translation.tr("Dwindle") },
                { icon: "view_column", value: "master", displayName: Translation.tr("Master") },
            ]
        }

        ConfigSwitch {
            buttonIcon: "call_split"
            text: Translation.tr("Preserve split")
            tooltip: Translation.tr("Keep split direction when opening new windows")
            checked: HyprlandConfig.get("dwindle:preserve_split") !== "false"
            onCheckedChanged: HyprlandConfig.set("dwindle:preserve_split", checked ? "true" : "false")
        }
    }

    // ── Cursor ──
    ContentSection {
        icon: "mouse"
        title: Translation.tr("Cursor")

        ConfigSwitch {
            buttonIcon: "center_focus_weak"
            text: Translation.tr("No focus fallback")
            tooltip: Translation.tr("Don't fall back to next window when moving focus with no window found")
            checked: HyprlandConfig.get("general:no_focus_fallback") === "true"
            onCheckedChanged: HyprlandConfig.set("general:no_focus_fallback", checked ? "true" : "false")
        }
        ConfigSpinBox {
            icon: "search"
            text: Translation.tr("Zoom factor")
            tooltip: Translation.tr("Cursor zoom level")
            value: parseFloat(HyprlandConfig.get("cursor:zoom_factor") ?? 1)
            from: 1; to: 5; stepSize: 0.5
            onValueChanged: HyprlandConfig.set("cursor:zoom_factor", value.toFixed(1))
        }
    }

    // ── Tearing ──
    ContentSection {
        icon: "flash_on"
        title: Translation.tr("Tearing")

        ConfigSwitch {
            buttonIcon: "flash_on"
            text: Translation.tr("Allow Tearing")
            tooltip: Translation.tr("Master switch for screen tearing support")
            checked: HyprlandConfig.get("general:allow_tearing") === "true"
            onCheckedChanged: HyprlandConfig.set("general:allow_tearing", checked ? "true" : "false")
        }
    }
}
