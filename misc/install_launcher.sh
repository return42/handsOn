#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update os
# ----------------------------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

# ----------------------------------------------------------------------------
installDesktopLauncher() {
    rstHeading "Desktop Launcher (OS-Update)"
# ----------------------------------------------------------------------------

    local LAUNCHER_FILENAME="handsOn_os_update.desktop"
    local LAUNCHER_FOLDER="$HOME/.local/share/applications"
    mkdir -p "$LAUNCHER_FOLDER"
    rstBlock "$LAUNCHER_FILENAME --> $LAUNCHER_FOLDER"

    tee "$LAUNCHER_FOLDER/$LAUNCHER_FILENAME" > /dev/null <<EOF
[Desktop Entry]
Name=OS update (handsOn)
Type=Application
Icon=system-software-update
Exec=gnome-terminal -- pkexec ${SCRIPT_FOLDER}/os_update.sh
Terminal=false
StartupNotify=true
GenericName=OS update (handsOn)
Comment=System update with the scripts from handsOn
Categories=Utility;
Keywords=update;system update
StartupWMClass=handsOn
EOF
}
installDesktopLauncher

