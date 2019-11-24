#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     google-deb.sh
# -- Copyright (C) 2019 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     NodeSource Node.js Binary Distribution
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# NODESOURCE_APT_URL
# ------------------
#
# Achtung! Um die Node.js Version zu wechseln kann die NODESOURCE_APT_URL angepasst
# werden, jedoch sollte man vorher ein "deinstall" durchführen.  Ggf. auch das
# Replacement |VER| in der Datei ./docs/nodejs/install.rst anpassen!

NODESOURCE_APT_URL="https://deb.nodesource.com/node_12.x"
NODESOURCE_APT_NAME="nodesource"

# NODESOURCE_APT_KEY_URL
# ----------------------
#
# Public Key von NodeSource

NODESOURCE_APT_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"

NODEJS_PACKAGES="\
  nodejs"

NPM_GLOBAL_PACKAGES="grunt-cli webpack webpack-cli lodash eslint @vue/cli @quasar/cli"

VSCODE_PACKAGES="code"
VSCODE_APT_DEB="https://packages.microsoft.com/repos/vscode"
VSCODE_APT_NAME="vscode"
VSCODE_PKEY_URL="https://packages.microsoft.com/keys/microsoft.asc"

# ----------------------------------------------------------------------------
README(){
# ----------------------------------------------------------------------------

    rstBlock "Installation aus der 'NodeSource Node.js Binary Distribution'

https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions

- Repository hinzufügen $NODESOURCE_APT_URL

- Hinzufügen des Public-Key von https://deb.nodesource.com

APT-Katalog aktualisieren und Installation des debian Pakets 'nodejs' aus den
neuen Paketquellen."

}
# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) install    all|nodejs|npm-global|vscode
  $(basename $0) remove     nodejs|npm-global|vscode
  $(basename $0) update     nodejs|npm-global|vscode

all:         Installation nodejs, npm-global und vscode
nodejs:      Aus der 'NodeSource Node.js Binary Distribution'
             ${NODESOURCE_APT_URL}
vscode:      Visual-Studio Code von Microsoft
             ${VSCODE_APT_DEB}
npm-global:  Installation der globalen NodeJS Pakete
             ${NPM_GLOBAL_PACKAGES}
EOF
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "Install Node.js (from NodeSource)" part
# ----------------------------------------------------------------------------

    case $1 in
        install)
            sudoOrExit
            case $2 in
		all)
		    nodesource_add_deb
		    install_nodejs_packages
		    install_npm_global_packages
		    install_vscode
		    ;;
                nodejs)
		    README
		    waitKEY
		    nodesource_add_deb
		    install_nodejs_packages
		    ;;
		npm-global)
		    install_npm_global_packages
		    ;;
		vscode)
		    install_vscode
		    ;;
                *)
		    usage $_usage
		    exit 42
		    ;;
            esac ;;
	update)
            case $2 in
                nodejs|npm-global)
		    update_npm_global_packages
		    ;;
		vscode)
		    update_vscode
		    ;;
                *)
		    usage $_usage
		    exit 42
		    ;;
            esac ;;
	remove)
            case $2 in
                nodejs)
		    deinstall_npm_global_packages
		    deinstall_nodejs_packages
		    nodesource_remove_deb
		    ;;
                npm-global)
		    deinstall_npm_global_packages
		    ;;
		vscode)
		    remove_vscode
		    ;;
                *)
		    usage $_usage
		    exit 42
		    ;;
            esac ;;
	*) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
           ;;
    esac
}

# ----------------------------------------------------------------------------
# deb.nodesource.com
# ----------------------------------------------------------------------------

nodesource_add_deb(){
    rstHeading "Einrichten der Paketquellen von *$NODESOURCE_APT_NAME*"

    rstHeading "Binaries $NODESOURCE_APT_NAME (deb)" section
    echo
    aptAddRepositoryURL "$NODESOURCE_APT_URL" "$NODESOURCE_APT_NAME" main

    rstHeading "Sources $NODESOURCE_APT_NAME (deb-src)" section
    echo
    aptAddRepositoryURL "$NODESOURCE_APT_URL" "$NODESOURCE_APT_NAME" main src
    waitKEY

    rstHeading "Eintragen des public-key von *$NODESOURCE_APT_NAME*" section
    echo
    aptAddPkeyFromURL "$NODESOURCE_APT_KEY_URL" "$NODESOURCE_APT_NAME"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    waitKEY
}

nodesource_remove_deb(){
    rstHeading "Entfernen der Paketquellen von *$NODESOURCE_APT_NAME*"
    echo
    aptRemoveRepository "$NODESOURCE_APT_NAME"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    waitKEY
}

# ----------------------------------------------------------------------------
# nodejs_packages
# ----------------------------------------------------------------------------

install_nodejs_packages(){
    rstHeading "Installation der debian Pakete"
    aptInstallPackages ${NODEJS_PACKAGES}
}

update_nodejs_packages(){
    rstHeading "Update debian Pakete für NodeJS"
    echo
    info_msg "Ein Update erfolgt auch automatisch bei jedem OS Update"
    apt-get update
    TITLE="Update deb-packages" aptInstallPackages ${NODEJS_PACKAGES}
}

deinstall_nodejs_packages(){
    rstHeading "Deinstallation der debian Pakete"
    aptPurgePackages ${NODEJS_PACKAGES}
}

# ----------------------------------------------------------------------------
# npm_global_packages
# ----------------------------------------------------------------------------

install_npm_global_packages(){
    rstHeading "Installation der globalen NodeJS Pakete"
    rstPkgList ${NPM_GLOBAL_PACKAGES}
    waitKEY
    npm install -g ${NPM_GLOBAL_PACKAGES}
}

update_npm_global_packages(){
    rstHeading "Update der global installierten NodeJS Pakete"
    rstPkgList npm ${NPM_GLOBAL_PACKAGES}
    waitKEY
    npm update -g npm ${NPM_GLOBAL_PACKAGES}
}

deinstall_npm_global_packages(){
    rstHeading "De-Installation der globalen NodeJS Pakete"
    rstPkgList ${NPM_GLOBAL_PACKAGES}
    waitKEY
    npm remove -g ${NPM_GLOBAL_PACKAGES}
}

# ----------------------------------------------------------------------------
# VSCode
# ----------------------------------------------------------------------------

install_vscode() {
    rstHeading "Installation VSCode" section

    local FNAME="/etc/apt/sources.list.d/${VSCODE_APT_NAME}.list"
    local DEB="deb [arch=amd64] ${VSCODE_APT_DEB} stable main"

    rstBlock "Die Installation aus den VSCode Paketquellen ist unter:

https://linuxize.com/post/how-to-install-visual-studio-code-on-debian-9

beschrieben.  Zuerst erfolgt die Installation erforderlicher Pakete um das
Reposetory von Microsoft später dann einzubinden .."

    aptInstallPackages software-properties-common apt-transport-https curl

    rstHeading "Repository einrichten" section
    # add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    # aptAddRepositoryURL "$VSCODE_APT_DEB" "$VSCODE_APT_NAME" main

    echo -e "add: ${Yellow}${DEB}${_color_Off}"
    echo -e "to:  ${Yellow}${FNAME}${_color_Off}"
    echo "" > "${FNAME}"
    echo "# added $(date)" >> "${FNAME}"
    echo "${DEB}" >> "${FNAME}"


    rstHeading "Public-Key für das Repository einrichten" section
    echo
    aptAddPkeyFromURL "$VSCODE_PKEY_URL" "${VSCODE_APT_NAME}"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update

    rstHeading "Installation der Pakete" section
    aptInstallPackages ${VSCODE_PACKAGES}
}

update_vscode(){
    rstHeading "Update der VSCode installation"
    echo
    info_msg "Ein Update erfolgt auch automatisch bei jedem OS Update"
    apt-get update
    TITLE="Update deb-packages" aptInstallPackages ${VSCODE_PACKAGES}
}

remove_vscode() {
    rstHeading "De-Installation VSCode" section
    aptPurgePackages ${VSCODE_PACKAGES}

    rstHeading "Entfernen der Paketquellen von $VSCODE_APT_NAME"
    echo
    aptRemoveRepository "$VSCODE_APT_NAME"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    waitKEY
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
