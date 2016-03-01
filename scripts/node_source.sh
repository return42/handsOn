#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
README(){
# ----------------------------------------------------------------------------

    rstBlock "Die Node.js Pakete des Ubuntu (bzw. debian) scheinen mir ziemlich
veraltet zu sein. Neuere Entwicklungen funktionieren damit i.d.R. nicht.
Alternativ kann man sich die *binaries* auch auf der Download-Seite von Node.js
runter laden:

  * https://nodejs.org/en/download/

Besser finde ich aber eine Installation über alternative debian Pakete. Dieses
Skript installiert alternative Paketquellen für Node.js. Das Verfahren resp die
apt-sourcen stammen von *NodeSource* :

  * https://github.com/nodesource/distributions#deb

Installiert wird die Version:

  * $APT_SOURCE_URL
"
}

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# APT_SOURCE_URL
# ------
#
# Achtung, die APT_SOURCE_URL kann angepasst werden, um die Node.js Version zu
# wechseln, jedoch sollte man vorher ein "deinstall" durchführen

APT_SOURCE_URL="https://deb.nodesource.com/node_4.x"
#APT_SOURCE_URL="https://deb.nodesource.com/node_0.12"

# APT_SOURCE_KEY_URL
# -----------
#
# Public Key von NodeSource

APT_SOURCE_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
APT_SOURCE_NAME="nodesource"

PACKAGES="\
  nodejs"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Install Node.js (from NodeSource)" part
# ----------------------------------------------------------------------------

    sudoOrExit
    case $1 in
	install)
            README
            waitKEY
            addDEB
            installPackages
	    ;;
	deinstall)
            deinstallPackages
            removeDEB
	    ;;
	*)
	    echo
            echo "usage $0 [install|deinstall]"
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
    waitKEY
}

# ----------------------------------------------------------------------------
deinstallPackages(){
# ----------------------------------------------------------------------------

    rstHeading "Deinstallation der debian Pakete"

    rstPkgList ${PACKAGES}
    echo
    waitKEY
    apt-get remove -y --purge ${PACKAGES}
    apt-get autoremove -y
    apt-get clean
    waitKEY
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------

