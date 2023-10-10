# dotfiles
![Screenshot](unix-screenshot.png)

# Paru

```
git clone https://aur.archlinux.org/paru.git | cd paru | makepkg -si
```

# Dependancies

```
paru -Syyu gnome-themes-extra gtk-engine-murrine emacs fd ripgrep vim visual-studio-code-bin nitrogen vivaldi vivaldi-ffmpeg-codecs noto-fonts nerd-fonts brightnessctl network-manager-applet file-roller neofetch pavucontrol blueberry lxappearance discord rofi git dmenu abs cron obquit caffeine-ng xautolock zoom flameshot picom-git polybar spotify awesome-git networkmanager-dmenu-git snap-pac-grub
```

# Theme

```
git https://github.com/vinceliuice/Graphite-gtk-theme
```
```
cd Graphite-gtk-theme/ | ./install.sh --gdm --tweaks black
```
```
cd other/grub2 | ./install.sh
```

# Icons

```
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
```
```
cd WhiteSur-icon-theme | ./install.sh --theme grey --alternative
```

# Snapshots

```
sudo snapper -c root create-config /
```
```
sudo systemctl enable snapper-timeline.timer snapper-cleanup.timer | sudo systemctl start snapper-timeline.timer snapper-cleanup.timer
```

# Dmenu Patch

```
mkdir /.dmenu | cd ~/.dmenu | paru -G dmenu
```
```
cd dmenu | wget http://tools.suckless.org/dmenu/patches/line-height/dmenu-lineheight-5.2.diff  | makepkg -o
```
```
cd src/dmenu-5.2 | patch -p1 < ~/.dmenu/dmenu/dmenu-lineheight-5.2.diff
```
```
sudo make clean install
```

# Bluetooth

```
sudo systemctl start bluetooth | sudo systemctl enable bluetooth
```

# Steam Flatpak

```
flatpak install flathub com.valvesoftware.Steam
```
```
sudo ln -s /var/lib/flatpak/exports/bin/com.valvesoftware.Steam /usr/bin/steam-flatpak
```
