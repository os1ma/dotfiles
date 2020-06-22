#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly VNC_PASSWORD="${VNC_PASSWORD:-password}"

exist_vncserver() {
  local vnc_server_id="$1"
  [[ "$(vncserver -list | grep "${vnc_server_id}" | wc -l)" -ne 0 ]]
}

sudo apt update

# X Window System, GNOME, VNC Server
sudo apt install -y ubuntu-desktop \
    gnome-core \
    gnome-panel \
    metacity \
    tigervnc-standalone-server

# VNC Setting
mkdir -p ~/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > ~/.vnc/passwd

cat << EOT > ~/.vnc/xstartup
exec gnome-session &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus -n &
gnome-terminal &
EOT

# start
if ! exist_vncserver :1; then
  vncserver :1
fi
