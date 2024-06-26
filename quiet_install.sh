#!/bin/bash

# Enable parallel downloads in pacman.conf
echo "Enabling parallel downloads in pacman.conf..."
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

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
paru -Syyu --noconfirm zsh xclip fish tmux tmux-plugin-manager xdg-desktop-portal-gtk flameshot npm go elixir docker docker-compose leafpad gnome-themes-extra gtk-engine-murrine emacs fd ripgrep vim visual-studio-code-bin nitrogen noto-fonts nerd-fonts brightnessctl network-manager-applet file-roller fastfetch pavucontrol blueberry lxappearance-gtk3 discord git xautolock zoom flameshot picom-git polybar networkmanager-dmenu-git asp
paru -Syyu --noconfirm neovim pcmanfm neovim leafpad flatpak feh picom-git clang git rpi-imager jellyfin-media-player ttf-font-awesome waybar swaylock swayidle i3exit light gparted stacer gnome-boxes rust-analyzer rustup visual-studio-code-bin linux-zen-headers nvidia-utils nvidia-dkms 

#tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Theme
echo "Installing theme..."
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme/
sudo ./install.sh --tweaks black --gdm
./install.sh --tweaks black
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

# Dmenu Patch
echo "Applying dmenu patch..."
mkdir ~/.dmenu
cd ~/.dmenu
paru -G dmenu-git
cd dmenu
wget http://tools.suckless.org/dmenu/patches/line-height/dmenu-lineheight-5.2.diff
makepkg -o
cd src/dmenu
patch -p1 < ~/.dmenu/dmenu-git/dmenu-lineheight-5.2.diff
sudo make clean install
cd
rm -rf ~/.dmenu

# Bluetooth
echo "Enabling bluetooth..."
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Steam Flatpak
echo "Installing Steam Flatpak..."
flatpak install -y flathub com.valvesoftware.Steam
sudo ln -s /var/lib/flatpak/exports/bin/com.valvesoftware.Steam /usr/bin/steam

# Proton-GE Flatpak
echo "Installing Proton-GE Flatpak"
flatpak install -y com.valvesoftware.Steam.CompatibilityTool.Proton-GE

# Vivaldi Flatpak
echo "Installing Vivaldi Flatpak"
flatpak install -y flathub com.vivaldi.Vivaldi
sudo ln -s /var/lib/flatpak/exports/bin/com.vivaldi.Vivaldi /usr/local/bin/vivaldi-flatpak

# OBS Flatpak
echo "Installing OBS Flatpak"
flatpak install -y flathub com.obsproject.Studio
sudo flatpak override --device=all com.obsproject.Studio
sudo ln -s /var/lib/flatpak/exports/bin/com.obsproject.Studio /usr/local/bin/obs

# Firefox Flatpak
echo "Installing Firefox Flatpak..."
flatpak install -y flathub org.mozilla.firefox
sudo ln -s /var/lib/flatpak/exports/bin/org.mozilla.firefox /usr/bin/firefox

# Librewolf Flatkpak
echo "Installing Librewolf Flatpak..."
flatpak install -y flathub io.gitlab.librewolf-community
sudo ln -s /var/lib/flatpak/exports/bin/io.gitlab.librewolf-community /usr/bin/librewolf

# OnlyOffice Flatpak
echo "Installing OnlyOffice Flatpak"
flatpak install -y flathub org.onlyoffice.desktopeditors
sudo ln -s /var/lib/flatpak/exports/bin/org.onlyoffice.desktopeditors /usr/bin/only-office

# Tor Browser Flatpak
echo "Installing Tor Browser Flatpak..."
flatpak install -y flathub com.github.micahflee.torbrowser-launcher
sudo ln -s /var/lib/flatpak/exports/bin/com.github.micahflee.torbrowser-launcher /usr/bin/tor-browser

# Logism Flatpak
echo "Installing Logisim Flatpak..."
flatpak install -y flathub com.github.reds.LogisimEvolution
sudo ln -s /var/lib/flatpak/exports/bin/com.github.reds.LogisimEvolution /usr/bin/logisim

# Spotify Flatpak
echo "Installing Spotify Flatpak..."
flatpak install -y flathub com.spotify.Client
sudo ln -s /var/lib/flatpak/exports/bin/com.spotify.Client /usr/bin/spotify

# Nvidia Driver Flatpak
echo "Instlling Nvidia Driver Flatpak..."
flatpak install -y flathub org.freedesktop.Platform.GL.nvidia-535-113-01

# Flatseal Flatpak
echo "Installing Flatseal..."
flatpak install -y flathub com.github.tchx84.Flatseal
sudo ln -s /var/lib/flatpak/exports/bin/com.github.tchx84.Flatseal /usr/bin/flatseal

# Add configuration to alsa-base.conf
echo "Configuring alsa-base.conf..."
echo "options snd-hda-intel model=asus-zenbook" | sudo tee -a /etc/modprobe.d/alsa-base.conf
echo "Configuration for alsa-base.conf complete!"

echo "Copying configuration files..."
cp -r ~/dotfiles/i3 ~/.config/
cp -r ~/dotfiles/polybar ~/.config/
cp -r ~/dotfiles/neofetch ~/.config/
cp -r ~/dotfiles/qtile ~/.config/
cp -r ~/dotfiles/picom ~/.config
cp -r ~/dotfiles/Wallpapers ~/
sudo cp -r ~/dotfiles/dunst /etc
sudo cp ~/dotfiles/obquit/obquit.conf /etc/obquit.conf
cd ~/.config/polybar
chmod +x launch.sh
chmod +x  ~/.config/polybar/scripts/get_primary_monitor.sh
chmod +x ~/.config/polybar/scripts/date_suffix.sh


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
mkdir ~/.scripts
cat > ~/.scripts/autoupdate.sh <<EOF
#!/bin/bash

# Update the system using paru
paru -Syu --noconfirm

# Optional: Clean up old versions of installed packages to save space
paru -Scc --noconfirm

# Update flatpaks
flatpak update -y
EOF

echo "Configuration complete!"
rm -rf ~/dotfiles
