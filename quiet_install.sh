#!/bin/bash

# Enable parallel downloads in pacman.conf
echo "Enabling parallel downloads in pacman.conf..."
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf

echo "Parallel downloads configuration for pacman complete!"

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install paru
echo "Installing paru..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru

# Install dependencies
echo "Installing dependencies..."
paru -Syyu --noconfirm grub-btrfs snapper flameshot protonvpn snap-pac snap-pac-grub gnome-themes-extra gtk-engine-murrine emacs fd ripgrep vim visual-studio-code-bin nitrogen vivaldi vivaldi-ffmpeg-codecs noto-fonts nerd-fonts brightnessctl network-manager-applet file-roller neofetch pavucontrol blueberry lxappearance-gtk3 discord rofi git dmenu cronie obquit caffeine-ng xautolock zoom flameshot picom-git polybar spotify awesome-git networkmanager-dmenu-git obsidian obquit asp
paru -S --noconfirm snap-pac-grub pcmanfm feh picom-git jellyfin-media-player ttf-font-awesome

# Theme
echo "Installing theme..."
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme/
sudo ./install.sh --tweaks black --gdm
./install.sh --tweaks black --gdm
cd other/grub2
./install.sh
cd ../../..
rm -rf Graphite-gtk-theme

# Icons
echo "Installing icons..."
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme/
sudo ./install.sh --theme grey --alternative
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
cd
rm -rf ~/.dmenu

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
flatpak install -y flathub com.valvesoftware.Steam
sudo ln -s /var/lib/flatpak/exports/bin/com.valvesoftware.Steam /usr/bin/steam-flatpak

# Add configuration to alsa-base.conf
echo "Configuring alsa-base.conf..."
echo "options snd-hda-intel model=asus-zenbook" | sudo tee -a /etc/modprobe.d/alsa-base.conf
echo "Configuration for alsa-base.conf complete!"

echo "Copying configuration files..."
cp -r ~/dotfiles/i3 ~/.config/
cp -r ~/dotfiles/polybar ~/.config/
cd ~/.config/polybar
chmod +x launch.sh
cd ~/.config/polybar/scripts
chmod +x get_primary_monitor.sh
cd
cp -r ~/dotfiles/neofetch ~/.config/
cp -r ~/dotfiles/qtile ~/.config/
cp -r ~/dotfiles/Wallpapers ~/
sudo cp -r ~/dotfiles/dunst /etc
sudo cp ~/dotfiles/obquit/obquit.conf /etc/obquit.conf

# Add g14 repo sign key
echo "Adding g14 repo sign key..."
sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

# Add g14 repo to pacman.conf
echo "Adding g14 repo to pacman.conf..."
echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf

# Run a full system update
echo "Updating system with the new repo..."
sudo pacman -Suy --noconfirm

# Asusctl installation and setup
echo "Installing asusctl..."
sudo pacman -S --noconfirm asusctl
# Enable power-profiles-daemon
echo "Enabling power-profiles-daemon.service..."
sudo systemctl enable --now power-profiles-daemon.service

# Supergfxctl installation and setup
echo "Installing supergfxctl..."
sudo pacman -S --noconfirm supergfxctl
# Enable supergfxd
echo "Enabling supergfxd service..."
sudo systemctl enable --now supergfxd

# ROG Control Center installation
echo "Installing ROG Control Center..."
sudo pacman -S --noconfirm rog-control-center

# Create the script
echo "Creating the autoupdate script..."

# Use a Here Document to generate the script file
cat > ~/autoupdate.sh <<EOF
#!/bin/bash

# Update the system using paru
paru -Syu --noconfirm

# Optional: Clean up old versions of installed packages to save space
paru -Scc --noconfirm

# Update flatpaks
flatpak update -y
EOF

# Make the script executable
chmod +x ~/autoupdate.sh

# Set up cronie if not already installed
if ! command -v cronie &> /dev/null; then
    echo "Installing cronie..."
    sudo pacman -S --noconfirm cronie

    # Start and enable the cronie service
    echo "Starting and enabling cronie service..."
    sudo systemctl start cronie
    sudo systemctl enable cronie
fi

# Add a cron job to run the script
echo "Setting up the cron job..."

# Open the crontab editor and add the job
(crontab -l 2>/dev/null; echo "0 2 * * * ~/autoupdate.sh") | crontab -



echo "Configuration complete!"
rm -rf ~/dotfiles
