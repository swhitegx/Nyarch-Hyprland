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

## Edit `steps.sh` to mimic `hyprlandbs.sh`
* hyprlandinstalldefault.sh is known to work and provide a hyprland enviroment. We need to study how it is different, may switch default iso builder to hyprlandtesting.sh/make a stable shell script to use.
* hyprlandinstalldefault.sh usually `cat`s stuff to the end of files mentioned. hyprland testing doenst do this since i can edit releng/ directly.
* hyprlandtesting.sh now copied from the releng mentioned in .gitignore. i will undo that when its finished.
* when hyprlandbs.sh builds an iso, it uses systemd-boot instead of grub.