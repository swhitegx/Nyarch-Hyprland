import sys
import os
import traceback

# Suppress GTK CSS parser warnings (they're harmless)
os.environ['G_MESSAGES_DEBUG'] = ''
os.environ['GTK_DEBUG'] = ''

# Increase recursion limit to handle hyprparser parsing issues
sys.setrecursionlimit(5000)

import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, Gio, GLib


def check_needs_setup():
    """Check if we need the first-run setup wizard.
    
    If Lua config exists (from dotfiles), skip setup — conf is supplementary.
    If no config at all exists, run setup.
    """
    has_lua = os.path.exists(os.path.expanduser("~/.config/hypr/hyprland.lua"))
    has_conf = os.path.exists(os.path.expanduser("~/.config/hypr/hyprland.conf"))
    if has_lua:
        return False
    return not has_conf


if check_needs_setup():
    from .modules.config_manager import download_default_config

    class SetupApplication(Adw.Application):
        def __init__(self):
            super().__init__(application_id='com.michaelmassoni.hyprset.setup', flags=Gio.ApplicationFlags.FLAGS_NONE)

    app = SetupApplication()
    app.run(None)

    if check_needs_setup():
        print("Setup incomplete. Exiting.", file=sys.stderr)
        sys.exit(1)

from .modules.app import MyApplication


def main() -> None:
    try:
        MyApplication.run()
    except KeyboardInterrupt:
        pass
    except BaseException as e:
        print(f"CRITICAL ERROR: {type(e).__name__}: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
    finally:
        exit(0)


if __name__ == '__main__':
    main()
