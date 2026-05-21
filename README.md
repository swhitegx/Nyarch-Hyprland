# Nyarch Hyprland
Draking it up w/ the ghost writers here NOTE: NOT ANYMORE, DOING IT MYSELF

# To Do
## Add pictures, grub theming, plymouth etc
* figuring out how to enable the wallpaper via hyprpaper - easy
* adding plymouth theme (adding plymouth to mkinitcpio.conf hooks{} portion) - easy
## finding dot files
* finding good dot files to use see [nyarch wiki](https://github.com/NyarchLinux/NyarchWiki/blob/master/docs/future_projects.md#hyprland-spin) for more info

## Edit `steps.sh` to mimic `hyprlandtesting.sh`
* hyprlanddefault.sh is not to be changed
* hyprlanddefault.sh copies /usr/share/archisox
* hyprlandtesting.sh now copied from the releng mentioned in .gitignore. i will undo that when its finished.
* when either scripts builds an iso, it uses systemd-boot instead of grub.

**Pretty Important**:
@ /etc/pacman.conf: the Siglevel to "Never" due to gpg error when downloading nyarch-keyring
@ /grub/grub.cfg: disabled the beeping
error when using end-4 dot files.
    leads to gray screen. Not sddm or grub issue.
