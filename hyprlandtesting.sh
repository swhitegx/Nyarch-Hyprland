#!/usr/bin/env bash

# BIG FUCKING THANKS TO @Michael91 IN THE OMARCHY DISCORD IF THIS WORKS I LOVE YOU FOREVER
# originally in https://github.com/nightdevil00/LinuxScripts/tree/main/ISO_Build/Hyprland-ISO
# edited by nyarch develowoper TotallyDIO the absolute genius (applause applause) to make nyarch hyprland
# ==============================================================================
# Custom Arch ISO Builder - Hyprland Live Environment
# Packages: fuzzel, nautilus, chromium, kitty, hyprland, gedit,
#           gnome-disk-utility, waybar
# User: live / Password: live (autologin via SDDM)
# ==============================================================================

set -euo pipefail

C_BLUE="\e[34m"; C_GREEN="\e[32m"; C_RED="\e[31m"; C_YELLOW="\e[33m"; C_RESET="\e[0m"
info() { echo -e "${C_BLUE}[INFO]${C_RESET} $1"; }
success() { echo -e "${C_GREEN}[SUCCESS]${C_RESET} $1"; }
error() { echo -e "${C_RED}[ERROR]${C_RESET} $1" >&2; exit 1; }
warn() { echo -e "${C_YELLOW}[WARNING]${C_RESET} $1"; }

[[ $EUID -eq 0 ]] || error "This script must be run as root"

# Cleans up anything old
[[ -d ./ezreleng ]] && rm -r ./ezreleng
[[ -d ./work ]] && rm -rf ./work
[[ -d ./out ]] && rm -rf ./out
sleep 2

# copies to ezreleng
cp -r /usr/share/archiso/configs/releng/ ./ezreleng
cp pacman.conf ./ezreleng/
cp profiledef.sh ./ezreleng/
cp packages.x86_64 ./ezreleng/
cp -r grub/ ./ezreleng/
cp -r efiboot/ ./ezreleng/
cp -r syslinux/ ./ezreleng/
cp -r etc/ ./ezreleng/airootfs/
cp -r opt/ ./ezreleng/airootfs/
cp -r usr/ ./ezreleng/airootfs/
mkdir -p ./ezreleng/airootfs/etc/skel
ln -sf /usr/share/ezarcher ./ezreleng/airootfs/etc/skel/ezarcher

WORK_DIR="$(pwd)/work"
PROFILE_DIR="$WORK_DIR/ezreleng"
OUT_DIR="$(pwd)/out"
AIROOTFS="$PROFILE_DIR/airootfs"

mkdir -p "$WORK_DIR" "$OUT_DIR"
[[ -d "$PROFILE_DIR" ]] && rm -rf "$PROFILE_DIR"

# ==============================================================================
# Copy base archiso profile
# ==============================================================================
info "Copying archiso releng profile..."
cp -r ./ezreleng "$WORK_DIR/"
chmod u+w "$PROFILE_DIR/profiledef.sh"

# ==============================================================================
# Airootfs structure
# ==============================================================================
info "Setting up airootfs..."
mkdir -p "$AIROOTFS/etc/skel/.config"/{hypr,kitty,fuzzel,waybar}
mkdir -p "$AIROOTFS/etc/skel/.local/share/applications"
mkdir -p "$AIROOTFS/etc/skel/.local/share/icons/hicolor/scalable/apps"
mkdir -p "$AIROOTFS/etc/sddm.conf.d"
mkdir -p "$AIROOTFS/etc/systemd/system"
mkdir -p "$AIROOTFS/root"

# ==============================================================================
# Enable services
# ==============================================================================
info "Enabling services..."
mkdir -p "$AIROOTFS/etc/systemd/system/multi-user.target.wants"
mkdir -p "$AIROOTFS/etc/systemd/system/graphical.target.wants"

ln -sf /usr/lib/systemd/system/sddm.service \
    "$AIROOTFS/etc/systemd/system/display-manager.service"
ln -sf /usr/lib/systemd/system/NetworkManager.service \
    "$AIROOTFS/etc/systemd/system/multi-user.target.wants/NetworkManager.service"
ln -sf /usr/lib/systemd/system/graphical.target \
    "$AIROOTFS/etc/systemd/system/default.target"

# ==============================================================================
# Desktop entry and icon for installer
# ==============================================================================
info "Creating desktop entry and icon for Arch Installer..."
cat > "$AIROOTFS/etc/skel/.local/share/applications/InstallArch.desktop" <<'DESKTOPDF'
[Desktop Entry]
Name=Install Arch Linux
Comment=Install Arch Linux to your system (offline/online/repair)
Exec=pkexec calamares
Icon=calamares
Terminal=false
Type=Application
Categories=System;
DESKTOPDF

# ==============================================================================
# User setup script (runs during build in airootfs chroot)
# ==============================================================================
info "Creating user setup script..."
cat > "$AIROOTFS/root/customize_airootfs.sh" <<'CUSTOMIZE_SCRIPT'
#!/usr/bin/env bash
set -e

echo "==> Creating live user..."

if ! id live &>/dev/null 2>&1; then
    useradd -m -u 1000 -G wheel,audio,video,network,storage -s /bin/bash live
    echo 'live:live' | chpasswd
fi

echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

cp -r /etc/skel/. /home/live/ 2>/dev/null || true
chown -R live:live /home/live

cat > /home/live/.bashrc <<'BASHRC_EOF'
[[ $- == *i* ]] && echo "Welcome to Hyprland Live ISO | User: live | Password: live"
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
alias ll='ls -la'
BASHRC_EOF

chown live:live /home/live/.bashrc
echo "==> User setup complete"
CUSTOMIZE_SCRIPT
chmod +x "$AIROOTFS/root/customize_airootfs.sh"

# ==============================================================================
# Copy arch-install script into ISO
# ==============================================================================
info "Copying install script into ISO..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ -f "$SCRIPT_DIR/../Arch_Install/arch_install.sh" ]]; then
    cp "$SCRIPT_DIR/../Arch_Install/arch_install.sh" "$AIROOTFS/etc/skel/"
else
    warn "arch_install.sh not found at $SCRIPT_DIR/../Arch_Install/arch_install.sh"
    warn "ISO will build without the install script (add it later to /etc/skel/)"
fi

# ==============================================================================
# Modify profiledef.sh to call our setup
# ==============================================================================
cat >> "$PROFILE_DIR/profiledef.sh" <<'PROFILEDEF_EOF'

file_permissions+=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/etc/skel/arch_install.sh"]="0:0:755"
)

customize_airootfs() {
    if [ -f "${airootfs_dir}/root/customize_airootfs.sh" ]; then
        arch-chroot "${airootfs_dir}" /root/customize_airootfs.sh
    fi
}
PROFILEDEF_EOF

# ==============================================================================
# Ask about offline installation packages
# ==============================================================================
echo ""
info "Include offline installation packages in the ISO?"
echo "This downloads base + Hyprland packages for installing without internet."
echo "Estimated extra size: ~2-3GB"
echo ""
echo "1) Yes - include offline packages"
echo "2) No - live environment only (smaller ISO)"
echo ""
read -rp "Choice [1-2]: " offline_choice

if [[ "$offline_choice" == "1" ]]; then
    info "Downloading packages for offline installation..."
    TMP_DL_DIR="/tmp/offline-pkgs-$$"
    OFFLINE_DIR="$AIROOTFS/opt/offline-pkgs"
    mkdir -p "$TMP_DL_DIR" "$OFFLINE_DIR"

    if ! pacman -Sw --cachedir "$TMP_DL_DIR" --noconfirm \
        base base-devel linux linux-firmware linux-headers \
        btrfs-progs cryptsetup efibootmgr grub limine \
        networkmanager sudo vim man-db man-pages \
        amd-ucode intel-ucode \
        pipewire pipewire-alsa pipewire-pulse wireplumber \
        hyprland xdg-desktop-portal-hyprland waybar kitty fuzzel \
        nautilus chromium gedit gnome-disk-utility \
        noto-fonts ttf-dejavu ttf-nerd-fonts-symbols bash-completion git curl wget; then
        warn "Some packages failed to download. Continuing with what we have."
    fi

    cp "$TMP_DL_DIR"/*.pkg.tar.zst "$OFFLINE_DIR/" 2>/dev/null || true
    rm -rf "$TMP_DL_DIR"

    repo-add "$OFFLINE_DIR/offline.db.tar.gz" "$OFFLINE_DIR"/*.pkg.tar.zst 2>/dev/null || true

    cat > "$AIROOTFS/etc/pacman.d/offline-mirrorlist" <<'REPOEOF'
# Offline package repository (from ISO)
Server = file:///opt/offline-pkgs
REPOEOF

    success "Offline packages: $(du -sh "$OFFLINE_DIR" | cut -f1)"
fi

# ==============================================================================
# Build ISO
# ==============================================================================
info "Starting mkarchiso build. This may take 15-30 minutes..."
cd "$WORK_DIR"
[[ -d "$PROFILE_DIR/work" ]] && rm -rf "$PROFILE_DIR/work"

mkarchiso -v -w "$PROFILE_DIR/work" -o "$OUT_DIR" "$PROFILE_DIR"

ISO_FILE=$(find "$OUT_DIR" -name "*.iso" -type f | sort | tail -1)

if [[ -n "$ISO_FILE" ]]; then
    success "ISO built successfully!"
    echo "Location: $ISO_FILE"
    echo "Size: $(du -h "$ISO_FILE" | cut -f1)"
    echo ""
    echo "Write to USB:"
    echo "  dd if=\"$ISO_FILE\" of=/dev/sdX bs=4M status=progress && sync"
    echo ""
    echo "Test with QEMU:"
    echo "  qemu-system-x86_64 -enable-kvm -m 4G -cdrom \"$ISO_FILE\""
else
    error "ISO file not found in $OUT_DIR"
fi

