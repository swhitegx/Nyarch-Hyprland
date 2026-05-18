# Nyarch Hyprland
Draking it up w/ the ghost writers here
^ NOT ANYMORE, DOING IT MYSELF

# To Do
## Add packages/add hyprland
* pretty self explanatory, just need to add the hyprland packages to packages.x86_64 & make it boot
## Add pictures, grub theming, plymouth etc
* figuring out how to enable the wallpaper via hyprpaper
* adding grub theme to grub (easy)
* adding plymouth theme (adding plymouth to mkinitcpio.conf hooks{} portion)
## finding dot files
* finding good dot files to use see [nyarch wiki](https://github.com/NyarchLinux/NyarchWiki/blob/master/docs/future_projects.md#hyprland-spin) for more info

## Edit `steps.sh` to mimic `hyprlandtesting.sh`
* hyprlanddefault.sh is not to be changed
* hyprlanddefault.sh copies /usr/share/archisox
* hyprlandtesting.sh now copied from the releng mentioned in .gitignore. i will undo that when its finished.
* when either scripts builds an iso, it uses systemd-boot instead of grub.

**Pretty Important**: 
figure out how to add nyarch keyring without setting nyarch-repo's trust lvl to Never
    the pacman.conf at releng/ has the Siglevel to "Never"
@ /ezreleng/grub.cfg: disabled the beeping