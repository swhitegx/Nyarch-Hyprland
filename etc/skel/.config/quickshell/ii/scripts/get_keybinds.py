#!/usr/bin/env python3
"""
Fix for Hyprland 0.56.0's broken `hyprctl binds -j` JSON output.
The bug shifts field values between columns and leaves identifiers unquoted.

Reads the malformed JSON, repairs it, remaps the shifted fields,
and outputs valid JSON suitable for the Quickshell cheatsheet.
"""

import json
import re
import subprocess
import sys


def fix_hyprctl_binds() -> list[dict]:
    result = subprocess.run(
        ["hyprctl", "binds", "-j"], capture_output=True, text=True
    )
    raw = result.stdout

    # --- Step 1: Fix unquoted values in the raw JSON ---

    # Fix "keycode": VALUE — unquoted identifiers, digits, or mouse:N patterns
    # Must match before "allow_input_capture" fix because keycode values are
    # simpler (no spaces/colons in descriptions)
    raw = re.sub(
        r'"keycode":\s*([a-zA-Z0-9_:]+)',
        r'"keycode": "\1"',
        raw,
    )

    # Fix empty keycode: "keycode": ,  ->  "keycode": "",
    raw = re.sub(r'"keycode":\s*,', '"keycode": "",', raw)

    # Fix "allow_input_capture": VALUE — unquoted description text (may contain
    # spaces, colons, >> etc). Match everything until end of line or comma.
    raw = re.sub(
        r'"allow_input_capture":\s*([^,\n]+)',
        lambda m: '"allow_input_capture": "' + m.group(1).strip() + '"',
        raw,
    )

    # Fix remaining empty allow_input_capture
    raw = re.sub(r'"allow_input_capture":\s*,', '"allow_input_capture": "",', raw)

    # Fix "modmask": true/false  ->  "modmask": null
    raw = re.sub(r'"modmask":\s*(true|false)', '"modmask": null', raw)

    # Fix "key": "false" / "key": "true" (bogus values)  ->  "key": ""
    raw = re.sub(r'"key":\s*"(?:true|false)"', '"key": ""', raw)

    # Fix "description": "false"  ->  "description": "" (placeholder, will be remapped)
    raw = raw.replace('"description": "false"', '"description": ""')

    # --- Step 2: Parse the fixed JSON ---
    try:
        binds = json.loads(raw)
    except json.JSONDecodeError as e:
        print(
            f"[get_keybinds.py] ERROR: JSON still invalid after repair: {e}",
            file=sys.stderr,
        )
        print(f"[get_keybinds.py] Near: ...{raw[max(0, e.pos-40):e.pos+40]}...",
              file=sys.stderr)
        return []

    # --- Step 3: Remap shifted fields ---
    for bind in binds:
        # The real modmask value was shifted into the "submap" field
        try:
            bind["modmask"] = int(bind.get("submap", "0"))
        except (ValueError, TypeError):
            bind["modmask"] = 0

        # The real key name is in "keycode"
        bind["key"] = bind.get("keycode", "") or ""

        # The real description is in "allow_input_capture"
        desc = bind.get("allow_input_capture", "") or ""
        bind["description"] = desc
        bind["has_description"] = bool(desc.strip())

        # Clean up helper fields not needed by the frontend
        bind.pop("hold", None)
        bind.pop("locked", None)
        bind.pop("long_press", None)  # hyprland 0.56 field name variant
        bind.pop("non_consuming", None)
        bind.pop("auto_consuming", None)
        bind.pop("allow_input_capture", None)

    return binds


if __name__ == "__main__":
    binds = fix_hyprctl_binds()
    json.dump(binds, sys.stdout, indent=2, ensure_ascii=False)
