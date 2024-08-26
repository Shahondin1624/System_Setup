#!/bin/bash
#Query necessary data

SAMBAUSER=$(whoami)
REPOBASE="https://raw.githubusercontent.com/Shahondin1624/System_Setup/master"

# Prompt for the Samba user password
read -sp "Enter password for Samba user $SAMBAUSER: " sambapassword
echo

echo "Starting setup..."
codename=$(lsb_release -cs)
echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y && sudo flatpak update


echo "Installing development environment"
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "Installing JDK-21"
sudo apt install openjdk-21-jdk -y
echo "Installing Jetbrains Toolbox"
curl -fsSL "$REPOBASE/jetbrains_toolbox.sh" | bash
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
sudo flatpak override com.discordapp.Discord --filesystem=host

echo "Installing Cryptomator:"
flatpak install org.cryptomator.Cryptomator -y
sudo flatpak override org.cryptomator.Cryptomator --filesystem=host

# Create the systemd service file
SERVICE_FILE="$HOME/.config/systemd/user/cryptomator.service"
mkdir -p "$(dirname "$SERVICE_FILE")"
cat <<EOL > "$SERVICE_FILE"
[Unit]
Description=Cryptomator

[Service]
ExecStart=/usr/bin/flatpak run org.cryptomator.Cryptomator

[Install]
WantedBy=default.target
EOL
# Reload systemd manager configuration
systemctl --user daemon-reload

# Enable the service to start at boot
systemctl --user enable cryptomator.service

# Start the service immediately
systemctl --user start cryptomator.service

echo "Cryptomator has been set up to start at system boot."

echo "Installing Insync:"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb http://apt.insync.io/ubuntu $codename non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list
sudo apt update && sudo apt install insync -y

echo "Installing Edge:"
flatpak install com.microsoft.Edge -y
sudo flatpak override com.microsoft.Edge --filesystem=host

echo "Installing Obsidian:"
flatpak install md.obsidian.Obsidian -y
sudo flatpak override md.obsidian.Obsidian --filesystem=host

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
sudo flatpak override ch.protonmail.protonmail-bridge --filesystem=host

echo "Installing BorgBackup:"
sudo apt install borgbackup -y

echo "Installing Vorta:"
sudo apt install vorta -y

echo "Installing Samba:"
sudo apt install samba -y

echo "Installing VM Management:"
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y

echo "Installing Teams:"
flatpak install com.github.IsmaelMartinez.teams_for_linux -y
sudo flatpak override com.github.IsmaelMartinez.teams_for_linux --filesystem=host

echo "Installing VLC-Media Player:"
sudo apt install vlc -y

echo "Installing Gimp:"
sudo apt install gimp -y

# Save the current directory
CURRENT_DIR=$(pwd)

echo "Installing Yubico Authenticator:"
sudo apt install pcscd -y
sudo systemctl enable --now pcscd


# Define the download URL and target directory
URL="https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-linux.tar.gz"
TARGET_DIR="$HOME/Yubico"

# Create the target directory
mkdir -p "$TARGET_DIR"

# Download the tar.gz file
wget -O "$TARGET_DIR/yubico-authenticator-latest-linux.tar.gz" "$URL"

# Change to the target directory
cd "$TARGET_DIR"

# Unpack the tar.gz file
tar -xzf yubico-authenticator-latest-linux.tar.gz

# Remove the tar.gz file
rm yubico-authenticator-latest-linux.tar.gz

# Change to the new directory (assuming it is named 'yubico-authenticator')
cd yubico-authenticator*

# Make the desktop_integration.sh script executable
chmod +x desktop_integration.sh

# Run the desktop_integration.sh script with the -i option
./desktop_integration.sh -i

echo "Yubico Authenticator has been installed and desktop integration has been set up."

# Change back to the original directory
cd "$CURRENT_DIR"

echo "Installing htop:"
sudo apt install htop -y


echo "Configuring System..."

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

echo "Configuring shortcuts for commands:"
# Add the custom shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-system-monitor/']"

# Set the name, command, and binding for the custom shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-system-monitor/ name "custom-system-monitor"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-system-monitor/ command "gnome-system-monitor"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-system-monitor/ binding "<Control><Alt>Delete"
echo "Custom shortcut for launching GNOME System Monitor has been set to Ctrl+Alt+Delete"

echo "Configuring Tiling:"
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true

# Enable or disable window snapping
gsettings set org.gnome.shell.extensions.pop-shell snap-to-grid true
# Activate Active-Window-Hint
gsettings set org.gnome.shell.extensions.pop-shell show-active-hint true


echo "Configuring Samba:"
expect <<EOF
spawn sudo smbpasswd -a $SAMBAUSER
expect "New SMB password:"
send "$sambapassword\r"
expect "Retype new SMB password:"
send "$sambapassword\r"
expect eof
EOF
mkdir -p "$HOME/VM_Share/TwoWay"
mkdir -p "/$HOME/VM_Share/ReadOnly"
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo bash -c "cat <<EOT >> /etc/samba/smb.conf

[TwoWayShare]
path = $HOME/VM_Share/TwoWay
available = yes
valid users = $(whoami)
read only = no
browsable = yes
public = yes
writable = yes

[ReadOnly]
path = $HOME/VM_Share/ReadOnly
available = yes
valid users = $(whoami)
read only = yes
browsable = yes
public = yes
writable = no
EOT"


# Restart the Samba service
sudo systemctl restart smbd

echo "Samba setup completed successfully!"

echo "Installing GNOME-Extensions:"
echo "Skipping GNOME-Extensions..."
# sudo apt install gnome-shell-extensions -y
# sudo apt install curl jq -y
# curl -s https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer | sudo tee /usr/local/bin/gnome-shell-extension-installer > /dev/null
# sudo chmod +x /usr/local/bin/gnome-shell-extension-installer
# gnome-shell-extension-installer 120
# gnome-extensions enable system-monitor@paradoxxx.zero.gmail.com

echo "Setting Formats and Language:"
sudo update-locale LANG=en_US.UTF-8
gsettings set org.gnome.system.locale region 'de_DE.UTF-8'
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]"
gsettings set org.gnome.desktop.interface clock-format '24h'

echo "Configuring power-related settings:"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
system76-power profile performance

echo "Disabling the dock:"
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true

echo "Configuring Desktop Options:"
gsettings set org.gnome.shell.keybindings toggle-overview "['Super_L']"
gsettings set org.gnome.shell.extensions.pop-cosmic show-workspaces-button true
gsettings set org.gnome.shell.extensions.pop-cosmic show-applications-button true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-position 'left'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

echo "Configuring Default Applications:"
xdg-settings set default-web-browser microsoft-edge.desktop
xdg-mime default thunderbird.desktop x-scheme-handler/mailto
xdg-mime default vlc.desktop audio/mpeg
xdg-mime default vlc.desktop video/mp4
xdg-mime default vlc.desktop video/x-matroska
xdg-mime default vlc.desktop video/x-msvideo
xdg-mime default vlc.desktop video/x-ms-wmv

echo "Configuring Insync:"
# Define the ignore rules
IGNORE_RULES="**/out/**
**/build/**
**/target/**
**/node_modules/**
"

# Define the path to the Insync ignore rules file
IGNORE_FILE="$HOME/.config/Insync/ignore_rules"

# Create the ignore rules file and add the rules
mkdir -p "$(dirname "$IGNORE_FILE")"
echo "$IGNORE_RULES" > "$IGNORE_FILE"
echo "Ignore rules have been set up for Insync."

echo "Preparing folder mounting:"
mkdir "$HOME/Insync"
mkdir "$HOME/Steam"

echo "Setting user picture:"
USER_IMAGE_FILE="/tmp/user_picture.png"
wget -O "$USER_IMAGE_FILE" "$REPOBASE/user_picture.png"
sudo cp -f "$USER_IMAGE_FILE" "/var/lib/AccountsService/icons/$(whoami)"

echo "Setting desktop background:"
BACKGROUND_IMAGE_FILE="/tmp/desktop_background.png"
wget -O "$BACKGROUND_IMAGE_FILE" "$REPOBASE/desktop_background.png"
gsettings set org.gnome.desktop.background picture-uri "file://$BACKGROUND_IMAGE_FILE"

echo "Copying aliases:"
wget -O "$HOME/.bash_aliases" TODO
# Append the sourcing of .bash_aliases to .bashrc if not already present
if ! grep -q 'source ~/.bash_aliases' "$HOME/.bashrc"; then
    echo 'if [ -f ~/.bash_aliases ]; then' >> "$HOME/.bashrc"
    echo '    . ~/.bash_aliases' >> "$HOME/.bashrc"
    echo 'fi' >> "$HOME/.bashrc"
fi
source "$HOME/.bashrc"



echo "Finished installation!"
neofetch
