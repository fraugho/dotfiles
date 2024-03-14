# Dotfiles
![Screenshot](unix-screenshot.png)

# Hands-off Install

```
sudo pacman -S git
```
```
git clone https://github.com/fraugho/dotfiles.git
```
```
cd dotfiles
```
```
chmod +x quiet_install.sh
```
```
./quiet_install.sh
```


# Paru

```
git clone https://aur.archlinux.org/paru.git | cd paru | makepkg -si
```

# Theme

```
git clone https://github.com/vinceliuice/Graphite-gtk-theme
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
