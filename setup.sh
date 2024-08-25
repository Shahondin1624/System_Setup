#!/bin/bash
echo "Starting setup..."
codename=$(lsb_release -cs)
echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y && sudo flatpak update


echo "Installing development environment"
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "Installing JDK-21"
sudo apt install openjdk-21-jdk
echo "Installing Jetbrains Toolbox"
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
echo "Installing Docker:"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


echo "Installing additional programs..."
echo "Install Steam:"
sudo apt install steam steam-devices -y

echo "Installing Spotify:"
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install spotify-client -y

echo "Installing Discord:"
sudo apt install discord -y

echo "Installing Cryptomator:"
flatpak install org.cryptomator.Cryptomator -y

echo "Installing Insync:"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insync.io/ubuntu $codename non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list
sudo apt update && sudo apt install insync -y

echo "Installing Edge:"
flatpak install com.microsoft.Edge -y

echo "Installing Obsidian:"
flatpak install md.obsidian.Obsidian -y

echo "Installing NeoFetch:"
sudo apt install neofetch -y

echo "Installing Thunderbird:"
sudo apt install thunderbird -y && sudo apt install birdtray -y

echo "Installing Proton VPN:"
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.4_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.4_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop -y
sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator -y

echo "Installing Proton Mail Bridge:"
flatpak install ch.protonmail.protonmail-bridge -y

echo "Installing BorgBackup:"
sudo apt install borgbackup -y

echo "Installing Vorta:"
sudo apt install vorta -y

echo "Installing VM Management:"
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y

echo "Installing Teams:"
flatpak install com.github.IsmaelMartinez.teams_for_linux -y


echo "Configuring System..."
echo "Show seconds on clock"
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Minimize window
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"

# Maximize window
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"

# Move window to the monitor on the left
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Super><Shift>Left']"

# Move window to the monitor on the right
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Super><Shift>Right']"

# Move to workspace 1
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"

# Move to workspace 2
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"

# Move to workspace 3
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"

# Move to workspace 4
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"

# Move window to workspace 1
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"

# Move window to workspace 2
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"

# Move window to workspace 3
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"

# Move window to workspace 4
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"

# Lock the system
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

echo "Keyboard shortcuts have been set!"

# Enable auto-tiling
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true

# Enable or disable window snapping
gsettings set org.gnome.shell.extensions.pop-shell snap-to-grid true
# Activate Active-Window-Hint
gsettings set org.gnome.shell.extensions.pop-shell show-active-hint true




echo "Finished installation!"
neofetch
