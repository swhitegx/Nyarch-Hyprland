import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    // ── Rounding ──
    ContentSection {
        icon: "rounded_corner"
        title: Translation.tr("Rounding")

        ConfigSpinBox {
            icon: "rounded_corner"
            text: Translation.tr("Rounding radius")
            tooltip: Translation.tr("Window corner roundness in pixels")
            value: HyprlandConfig.get("decoration:rounding") ?? 18
            from: 0; to: 40; stepSize: 1
            onValueChanged: HyprlandConfig.set("decoration:rounding", value)
        }
        ConfigSpinBox {
            icon: "line_curve"
            text: Translation.tr("Rounding power")
            tooltip: Translation.tr("2 = circle, higher = squircle")
            value: parseFloat(HyprlandConfig.get("decoration:rounding_power") ?? 2.5)
            from: 1; to: 6; stepSize: 0.5
            onValueChanged: HyprlandConfig.set("decoration:rounding_power", value.toFixed(1))
        }
    }

    // ── Opacity ──
    ContentSection {
        icon: "opacity"
        title: Translation.tr("Opacity")

        ConfigSlider {
            text: Translation.tr("Active opacity")
            value: parseFloat(HyprlandConfig.get("decoration:active_opacity") ?? 1.0)
            from: 0.1; to: 1.0; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:active_opacity", value.toFixed(2))
        }
        ConfigSlider {
            text: Translation.tr("Inactive opacity")
            value: parseFloat(HyprlandConfig.get("decoration:inactive_opacity") ?? 1.0)
            from: 0.1; to: 1.0; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:inactive_opacity", value.toFixed(2))
        }
        ConfigSlider {
            text: Translation.tr("Fullscreen opacity")
            value: parseFloat(HyprlandConfig.get("decoration:fullscreen_opacity") ?? 1.0)
            from: 0.1; to: 1.0; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:fullscreen_opacity", value.toFixed(2))
        }
    }

    // ── Blur ──
    ContentSection {
        icon: "blur_on"
        title: Translation.tr("Blur")

        ConfigSwitch {
            buttonIcon: "blur_on"
            text: Translation.tr("Enable blur")
            checked: HyprlandConfig.get("decoration:blur:enabled") ?? "true" === "true"
            onCheckedChanged: HyprlandConfig.set("decoration:blur:enabled", checked ? "true" : "false")
        }
        ConfigSpinBox {
            icon: "blur_on"
            text: Translation.tr("Blur size")
            value: parseInt(HyprlandConfig.get("decoration:blur:size") ?? 10)
            from: 1; to: 20; stepSize: 1
            onValueChanged: HyprlandConfig.set("decoration:blur:size", value)
        }
        ConfigSpinBox {
            icon: "repeat"
            text: Translation.tr("Blur passes")
            value: parseInt(HyprlandConfig.get("decoration:blur:passes") ?? 3)
            from: 1; to: 10; stepSize: 1
            onValueChanged: HyprlandConfig.set("decoration:blur:passes", value)
        }
        ConfigSlider {
            text: Translation.tr("Blur brightness")
            value: parseFloat(HyprlandConfig.get("decoration:blur:brightness") ?? 1.0)
            from: 0.5; to: 1.5; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:blur:brightness", value.toFixed(2))
        }
        ConfigSlider {
            text: Translation.tr("Blur contrast")
            value: parseFloat(HyprlandConfig.get("decoration:blur:contrast") ?? 0.89)
            from: 0.5; to: 1.5; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:blur:contrast", value.toFixed(2))
        }
        ConfigSlider {
            text: Translation.tr("Blur vibrancy")
            value: parseFloat(HyprlandConfig.get("decoration:blur:vibrancy") ?? 0.5)
            from: 0; to: 1; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:blur:vibrancy", value.toFixed(2))
        }
        ConfigSwitch {
            buttonIcon: "blur_linear"
            text: Translation.tr("Blur xray (popups only)")
            tooltip: Translation.tr("Only blur popup windows instead of full background")
            checked: HyprlandConfig.get("decoration:blur:xray") === "true"
            onCheckedChanged: HyprlandConfig.set("decoration:blur:xray", checked ? "true" : "false")
        }
    }

    // ── Shadow ──
    ContentSection {
        icon: "shadow"
        title: Translation.tr("Shadows")

        ConfigSwitch {
            buttonIcon: "shadow"
            text: Translation.tr("Enable shadows")
            checked: HyprlandConfig.get("decoration:shadow:enabled") ?? "true" === "true"
            onCheckedChanged: HyprlandConfig.set("decoration:shadow:enabled", checked ? "true" : "false")
        }
        ConfigSpinBox {
            icon: "loupe"
            text: Translation.tr("Shadow range")
            value: parseInt(HyprlandConfig.get("decoration:shadow:range") ?? 20)
            from: 0; to: 40; stepSize: 1
            onValueChanged: HyprlandConfig.set("decoration:shadow:range", value)
        }
        ConfigSpinBox {
            icon: "opacity"
            text: Translation.tr("Shadow render power")
            value: parseInt(HyprlandConfig.get("decoration:shadow:render_power") ?? 10)
            from: 1; to: 10; stepSize: 1
            onValueChanged: HyprlandConfig.set("decoration:shadow:render_power", value)
        }
    }

    // ── Dim ──
    ContentSection {
        icon: "dark_mode"
        title: Translation.tr("Dim")

        ConfigSwitch {
            buttonIcon: "dark_mode"
            text: Translation.tr("Dim inactive windows")
            checked: HyprlandConfig.get("decoration:dim_inactive") === "true"
            onCheckedChanged: HyprlandConfig.set("decoration:dim_inactive", checked ? "true" : "false")
        }
        ConfigSlider {
            text: Translation.tr("Dim strength")
            value: parseFloat(HyprlandConfig.get("decoration:dim_strength") ?? 0.05)
            from: 0; to: 1; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:dim_strength", value.toFixed(2))
        }
        ConfigSlider {
            text: Translation.tr("Dim special workspace")
            value: parseFloat(HyprlandConfig.get("decoration:dim_special") ?? 0.2)
            from: 0; to: 1; stepSize: 0.05
            onValueChanged: HyprlandConfig.set("decoration:dim_special", value.toFixed(2))
        }
    }
}
