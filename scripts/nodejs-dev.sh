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

  * https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions

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

APT_SOURCE_URL="https://deb.nodesource.com/node_10.x"

# APT_SOURCE_KEY_URL
# -----------
#
# Public Key von NodeSource

APT_SOURCE_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
APT_SOURCE_NAME="nodesource"

PACKAGES="\
  nodejs"

NPM_GLOBAL_PACKAGES="grunt-cli @vue/cli"

VSCODE_PACKAGES="code"
VSCODE_APT_DEB="https://packages.microsoft.com/repos/vscode"
VSCODE_APT_NAME="vscode"
VSCODE_PKEY_URL="https://packages.microsoft.com/keys/microsoft.asc"

# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) install    nodejs|vscode
  $(basename $0) remove     nodejs|vscode

nodejs:
vscode:     install Visual-Studio Code from M$

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
                nodejs)
		    README
		    waitKEY
		    addDEB
		    installPackages
		    ;;
		vscode)
		    install_vscode
		    ;;
                *)
		    usage $_usage
		    exit 42
		    ;;
            esac ;;
	remove)
            case $2 in
                nodejs)
		    deinstallPackages
		    removeDEB
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
    npm install -g ${NPM_GLOBAL_PACKAGES}
    waitKEY
}

# ----------------------------------------------------------------------------
deinstallPackages(){
# ----------------------------------------------------------------------------

    rstHeading "Deinstallation der debian Pakete"

    rstPkgList ${PACKAGES}
    echo
    waitKEY
    npm remove -g ${NPM_GLOBAL_PACKAGES}
    apt-get remove -y --purge ${PACKAGES}
    apt-get autoremove -y
    apt-get clean
    waitKEY
}

# ----------------------------------------------------------------------------
install_vscode() {
    rstHeading "Installation VSCode" section
# ----------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------
remove_vscode() {
    rstHeading "De-Installation VSCode" section
# ----------------------------------------------------------------------------

    rstHeading "Deinstallation der debian Pakete"

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

