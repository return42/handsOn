#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     instal handsOn launcher
# ----------------------------------------------------------------------------

source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"
exitOnSudo

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
Name=handsOn (OS Update)
Type=Application
Icon=system-software-update
Exec=gnome-terminal -- ${REPO_ROOT}/update/update_all.sh
Terminal=false
StartupNotify=false
GenericName=handsOn (OS update)
Comment=System update with the scripts from handsOn
Categories=Utility;
Keywords=update;system update
StartupWMClass=handsOn
EOF
}
installDesktopLauncher

