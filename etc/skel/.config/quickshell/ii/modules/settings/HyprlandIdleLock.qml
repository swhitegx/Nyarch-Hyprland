import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    // ── Hypridle timeouts ──
    ContentSection {
        icon: "timer"
        title: Translation.tr("Idle timeouts")
        tooltip: Translation.tr("Timeouts are in seconds. Set to 0 to disable.")

        ConfigSpinBox {
            icon: "lock"
            text: Translation.tr("Lock after (s)")
            value: parseInt(HyprlandConfig.get("idle:lock_timeout") ?? 300)
            from: 0; to: 3600; stepSize: 30
            onValueChanged: HyprlandConfig.set("idle:lock_timeout", value)
        }
        ConfigSpinBox {
            icon: "dark_mode"
            text: Translation.tr("DPMS off after (s)")
            value: parseInt(HyprlandConfig.get("idle:dpms_timeout") ?? 600)
            from: 0; to: 7200; stepSize: 30
            onValueChanged: HyprlandConfig.set("idle:dpms_timeout", value)
        }
        ConfigSpinBox {
            icon: "power"
            text: Translation.tr("Suspend after (s)")
            value: parseInt(HyprlandConfig.get("idle:suspend_timeout") ?? 900)
            from: 0; to: 7200; stepSize: 30
            onValueChanged: HyprlandConfig.set("idle:suspend_timeout", value)
        }
    }

    // ── Hyprlock ──
    ContentSection {
        icon: "lock"
        title: Translation.tr("Lock screen")

        ConfigRow {
            ConfigSpinBox {
                icon: "text_fields"
                text: Translation.tr("Clock font size")
                value: parseInt(HyprlandConfig.get("lock:clock_font_size") ?? 65)
                from: 20; to: 200; stepSize: 5
                onValueChanged: HyprlandConfig.set("lock:clock_font_size", value)
            }
            ConfigSpinBox {
                icon: "text_fields"
                text: Translation.tr("Date font size")
                value: parseInt(HyprlandConfig.get("lock:date_font_size") ?? 17)
                from: 10; to: 80; stepSize: 2
                onValueChanged: HyprlandConfig.set("lock:date_font_size", value)
            }
        }
        ConfigSpinBox {
            icon: "border_all"
            text: Translation.tr("Input outline thickness")
            value: parseInt(HyprlandConfig.get("lock:outline_thickness") ?? 2)
            from: 0; to: 10; stepSize: 1
            onValueChanged: HyprlandConfig.set("lock:outline_thickness", value)
        }
    }

    // ── Widget hint ──
    ContentSection {
        icon: "info"
        title: Translation.tr("Note")
        StyledText {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            color: Appearance.colors.colSubtext
            text: Translation.tr("For more lock screen styling options (colors, fonts, background), edit hyprlock.conf directly at:\n~/.config/hypr/hyprlock.conf")
            wrapMode: Text.WordWrap
        }
    }
}
