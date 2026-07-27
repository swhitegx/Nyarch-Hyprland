#!/bin/bash
# customize_airootfs.sh — Enable system services for live ISO

set -e

echo "==> Enabling system services..."
systemctl enable bluetooth
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable plymouth-start

echo "==> Creating live user with fish shell..."
if ! id live &>/dev/null 2>&1; then
    useradd -m -u 1000 -G wheel,audio,video,network,storage -s /usr/bin/fish live
    echo 'live:live' | chpasswd
fi

echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# Copy skel configs to live home
cp -r /etc/skel/. /home/live/ 2>/dev/null || true
chown -R live:live /home/live

# Set up fastfetch config for nyaofetch
mkdir -p /home/live/.config/fastfetch
if [ -d /usr/share/nyarcher/fastfetch ]; then
    cp /usr/share/nyarcher/fastfetch/config_extended.jsonc /home/live/.config/fastfetch/
    cp /usr/share/nyarcher/fastfetch/ascii* /home/live/.config/fastfetch/ 2>/dev/null || true
    chown -R live:live /home/live/.config/fastfetch
fi

# Also copy to skel so new users get it
if [ -d /usr/share/nyarcher/fastfetch ]; then
    mkdir -p /etc/skel/.config/fastfetch
    cp /usr/share/nyarcher/fastfetch/config_extended.jsonc /etc/skel/.config/fastfetch/
    cp /usr/share/nyarcher/fastfetch/ascii* /etc/skel/.config/fastfetch/ 2>/dev/null || true
fi

echo "==> User setup complete"
