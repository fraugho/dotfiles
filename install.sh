#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu

# Install paru
echo "Installing paru..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

# Install dependencies
echo "Installing dependencies..."
paru -Syyu gnome-themes-extra gtk-engine-murrine emacs fd ripgrep vim visual-studio-code-bin nitrogen vivaldi vivaldi-ffmpeg-codecs noto-fonts nerd-fonts brightnessctl network-manager-applet file-roller neofetch pavucontrol blueberry lxappearance discord rofi git dmenu abs cron obquit caffeine-ng xautolock zoom flameshot picom-git polybar spotify awesome-git networkmanager-dmenu-git snap-pac-grub obsidian

# Theme
echo "Installing theme..."
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme/
./install.sh --gdm --tweaks black
cd other/grub2
./install.sh
cd ../../..
rm -rf Graphite-gtk-theme

# Icons
echo "Installing icons..."
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme/
./install.sh --theme grey --alternative
cd ..
rm -rf WhiteSur-icon-theme

# Snapshots
echo "Configuring snapshots..."
sudo snapper -c root create-config /
sudo systemctl enable snapper-timeline.timer snapper-cleanup.timer
sudo systemctl start snapper-timeline.timer snapper-cleanup.timer

# Dmenu Patch
echo "Applying dmenu patch..."
mkdir ~/.dmenu
cd ~/.dmenu
paru -G dmenu
cd dmenu
wget http://tools.suckless.org/dmenu/patches/line-height/dmenu-lineheight-5.2.diff
makepkg -o
cd src/dmenu-5.2
patch -p1 < ~/.dmenu/dmenu/dmenu-lineheight-5.2.diff
sudo make clean install
cd ../../..
rm -rf dmenu

# Doom Emacs
echo "Installing Doom Emacs..."
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

# Bluetooth
echo "Enabling bluetooth..."
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Steam Flatpak
echo "Installing Steam flatpak..."
flatpak install flathub com.valvesoftware.Steam
sudo ln -s /var/lib/flatpak/exports/bin/com.valvesoftware.Steam /usr/bin/steam-flatpak

# Add g14 repo sign key
echo "Adding g14 repo sign key..."
pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

# Add g14 repo to pacman.conf
echo "Adding g14 repo to pacman.conf..."
echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf

# Run a full system update
echo "Updating system with the new repo..."
sudo pacman -Suy

# Asusctl installation and setup
echo "Installing asusctl..."
sudo pacman -S asusctl
# Enable power-profiles-daemon
echo "Enabling power-profiles-daemon.service..."
sudo systemctl enable --now power-profiles-daemon.service

# Supergfxctl installation and setup
echo "Installing supergfxctl..."
sudo pacman -S supergfxctl
# Enable supergfxd
echo "Enabling supergfxd service..."
sudo systemctl enable --now supergfxd

# ROG Control Center installation
echo "Installing ROG Control Center..."
sudo pacman -S rog-control-center

echo "Installation complete!"

