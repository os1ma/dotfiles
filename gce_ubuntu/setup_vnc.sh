#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly VNC_PASSWORD="${VNC_PASSWORD:-password}"
readonly VNC_DISPLAY=':1'

exist_vncserver() {
  local vnc_display="$1"
  [[ "$(vncserver -list | grep "${vnc_display}" | wc -l)" -ne 0 ]]
}

# state validation
if exist_vncserver "${VNC_DISPLAY}"; then
  echo "VNC display "${VNC_DISPLAY}" already exists."
  exit 0
fi

# X Window System, GNOME, VNC Server
sudo apt update
sudo apt install -y ubuntu-desktop \
    gnome-core \
    gnome-panel \
    metacity \
    tigervnc-standalone-server

# set password
cat << EOT | vncpasswd
${VNC_PASSWORD}
${VNC_PASSWORD}
EOT

exit 1

# initialize
vncserver "${VNC_DISPLAY}"
vncserver -kill "${VNC_DISPLAY}"

cat << EOT > ~/.vnc/xstartup
exec gnome-session &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus -n &
gnome-terminal &
EOT

# start
vncserver "${VNC_DISPLAY}"
