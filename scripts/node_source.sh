#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# APT_SOURCE_URL
# ------
#
# Achtung, die APT_SOURCE_URL kann angepasst werden, um die Node.js Version zu
# wechseln, jedoch sollte man vorher ein "deinstall" durchführen

APT_SOURCE_URL="https://deb.nodesource.com/node_12.x"

# APT_SOURCE_KEY_URL
# -----------
#
# Public Key von NodeSource

APT_SOURCE_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
APT_SOURCE_NAME="nodesource"

PACKAGES="\
  nodejs"

NPM_PACKAGES="\
  grunt-cli"

# ----------------------------------------------------------------------------
README(){
# ----------------------------------------------------------------------------

    rstBlock "Installation aus der 'NodeSource Node.js Binary Distribution'

https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions

- Repository hinzufügen $APT_SOURCE_URL

- Hinzufügen des Public-Key von https://deb.nodesource.com

APT-Katalog aktualisieren und Installation des debian Pakets 'nodejs' aus den
neuen Paketquellen."
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "Install Node.js (from NodeSource)" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
	    sudoOrExit
            README
	    info_msg "Ggf. konfligierende Pakete werden deinstalliert ..."
            waitKEY
	    apt-get remove -f -y --purge nodejs npm
            waitKEY
            addDEB
            installPackages
	    ;;
	remove)
	    sudoOrExit
            deinstallPackages
            removeDEB
	    ;;
	README)
	    README ;;
	*)
	    echo
            echo "usage $0 [install|remove|README]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
addDEB(){
# ----------------------------------------------------------------------------

    rstHeading "Einrichten der Paketquellen von *$APT_SOURCE_NAME*"

    rstHeading "Binaries $APT_SOURCE_NAME (deb)" section
    echo
    aptAddRepositoryURL "$APT_SOURCE_URL" "$APT_SOURCE_NAME" main

    rstHeading "Sources $APT_SOURCE_NAME (deb-src)" section
    echo
    aptAddRepositoryURL "$APT_SOURCE_URL" "$APT_SOURCE_NAME" main src
    waitKEY

    rstHeading "Eintragen des public-key von *$APT_SOURCE_NAME*" section
    echo
    aptAddPkeyFromURL "$APT_SOURCE_KEY_URL" "$APT_SOURCE_NAME"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    waitKEY

}

# ----------------------------------------------------------------------------
removeDEB(){
# ----------------------------------------------------------------------------

    rstHeading "Entfernen der Paketquellen von *$APT_SOURCE_NAME*"
    echo
    aptRemoveRepository "$APT_SOURCE_NAME"
    waitKEY

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    waitKEY
}

# ----------------------------------------------------------------------------
installPackages(){
# ----------------------------------------------------------------------------

    rstHeading "Installation der debian Pakete"
    rstPkgList ${PACKAGES}
    echo
    waitKEY
    apt-get install -y ${PACKAGES}
    npm install -g ${NPM_PACKAGES}
    waitKEY
}

# ----------------------------------------------------------------------------
deinstallPackages(){
# ----------------------------------------------------------------------------

    rstHeading "Deinstallation der debian Pakete"

    rstPkgList ${PACKAGES}
    echo
    waitKEY
    npm remove -g ${NPM_PACKAGES}
    apt-get remove -y --purge ${PACKAGES}
    apt-get autoremove -y
    apt-get clean
    waitKEY
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------

