#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Desktop Setup
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GNOME_SHELL_EXTENSIONS="/usr/share/gnome-shell/extensions"

GNOME3_PACKAGES="\
 ubuntu-gnome-desktop \
 ubuntu-gnome-wallpapers \
 tracker-gui \
 gnome-tweak-tool gconf-editor \
 elementary-icon-theme \
 gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 \
"
# ubuntu-gnome-default-settings \

DISPLAY_MANAGER_PACKAGES="\
  gdm \
  lightdm lightdm-webkit-greeter \
"
#  sddm \
#  kdm \
#  ldm \

CINNAMON_PACKAGES="cinnamon-desktop-environment"
MATE_PACKAGES="mate-desktop-environment"
UNITY_REMOVE_PACKAGES="$(dpkg-query -f '${binary:Package} ' -W 'unity*')"

# elementary
# ----------
#
# Die Installation ist nicht mit ubuntu 15.04 oder 15.10 möglich. Erst ab 16.04
# scheint es wieder einen Support in dem PPA zu geben (zumindest in daily
# scheint was vorgesehen).
#
# Bevor man das PPA wechselt sollte man zuvor remove_elementary aufgerufen
# haben. Ansonsten verbleiben ggf. noch *Paketreste* aus dem alten PPA.
#
# siehe https://launchpad.net/~elementary-os
#
#ELEMENTARY_PPA="ppa:elementary-os/stable"
#ELEMENTARY_PPA="ppa:elementary-os/daily"

ELEMENTARY_PPA="ppa:elementary-os/staging"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Desktop System" part
# ----------------------------------------------------------------------------

    sudoOrExit
    case $1 in
        gnomeShell)
            install_gnomeShell
            ;;
	cinnamon)
            TITLE="Installation Cinnamon-Desktop" aptInstallPackages ${CINNAMON_PACKAGES}
            ;;
	remove_cinnamon)
            TITLE="Installation Cinnamon-Desktop" aptPurgePackages ${CINNAMON_PACKAGES}
            ;;
	mate)
            TITLE="Installation Mate-Desktop"  aptInstallPackages ${MATE_PACKAGES}
            ;;
	remove_mate)
            TITLE="De-Installation Mate-Desktop" aptPurgePackages ${MATE_PACKAGES}
            ;;
        elementary)
            install_elementary
            ;;
        remove_elementary)
            remove_elementary
            ;;
        remove_unity)
            remove_unity
            ;;
        chooseDM)
            chooseDM;;
        *)
            echo
	    echo "usage $0 [chooseDM|gnomeShell|remove_[unity|elementary|cinnamon|mate]]"
            echo
            ;;
    esac
}


# ----------------------------------------------------------------------------
chooseDM() {
    rstHeading "Auswahl eines DISPLAY Managers"
# ----------------------------------------------------------------------------
    echo
    apt-get install -y ${DISPLAY_MANAGER_PACKAGES}
    dpkg-reconfigure lightdm

    # FIXME: in 1510 funktioniert das lightdm-webkit-greeter Paket nicht. Man
    # muss es mit *irgendwelchen* anderen Paketen installieren. Welche Pakete
    # das sind weiß ich nicht. Ich merke nur, dass es mal funktioniert mal nicht
    # und ich sehe in den LOGs (/var/log/lightdm/), dass da noch was ziemlich
    # buggy zu sein scheint. Z.B. wird ein LOG-Ordner unter
    # /var/log/lightdm/<user-name> angelegt. Der *Greeter* selber versucht dann
    # aber unter /var/lib/lightdm/ seine Daten abzulegen, was am Ende scheitert.

    mkdir -p /var/lib/lightdm
    chown lightdm:lightdm /var/lib/lightdm

    # Diese kleine Workaround reicht allerdings noch nicht. Ich gebe das an
    # dieser Stelle auf, mit scheint das Paket einfach nur Buggy zu sein.  Siehe
    # https://launchpad.net/lightdm-webkit-greeter/trunk In Ubuntu 1504 wird
    # Version 0.1.2 genutzt, das ist von 2012. Inzwischen gibt es *volle*
    # Versionsnummern, z.B 1.0.0 vom Oktober 2015 und 2.0.0 vom Jan. 2016. Beide
    # haben es aber in noch keine Distro geschafft, selbst in 1604 ist momentan
    # noch
    #
    # * https://launchpad.net/lightdm-webkit-greeter/trunk
    # * https://launchpad.net/ubuntu/xenial/+source/lightdm-webkit-greeter

    waitKEY
}


# ----------------------------------------------------------------------------
install_elementary() {
    rstHeading "Installation elementary"
# ----------------------------------------------------------------------------

    rstBlock ".. hint::

  Die Installation ist nicht mit ubuntu 15.04 oder 15.10 möglich. Erst ab 16.04
  scheint es wieder einen Support in dem PPA zu geben."

    if askYn "Soll die Installation durchgeführt werden?"; then
        echo
        add-apt-repository --yes "${ELEMENTARY_PPA}"
        waitKEY
        apt-get update
        apt-get install elementary-desktop
    else
        rstBlock "Installation von elementary-desktop abgebrochen."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
remove_elementary() {
    rstHeading "De-Installation elementary"
# ----------------------------------------------------------------------------

    echo
    apt-get purge elementary-desktop
    waitKEY
    add-apt-repository --yes --remove "${ELEMENTARY_PPA}"
    apt-get update
    waitKEY
}


# ----------------------------------------------------------------------------
remove_unity(){
    rstHeading "De-Installation von Unity"
# ----------------------------------------------------------------------------

    rstPkgList ${UNITY_REMOVE_PACKAGES}
    if askYn "Soll Unity komplett deinstalliert werden?"; then
        apt-get purge --ignore-missing -y ${UNITY_REMOVE_PACKAGES}
        apt-get -y autoremove
    fi
}



# ----------------------------------------------------------------------------
install_gnomeShell(){
    rstHeading "Gnome-Shell"
# ----------------------------------------------------------------------------

    rstPkgList ${GNOME3_PACKAGES}

    if ! askYn "Sollen die Gnome-Shell Pakete installiert werden?"; then
        return 42
    fi
    echo
    apt-get install -y ${GNOME3_PACKAGES}
    rstHeading "Installation der Gnome-Shell Extensions"

    # https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet

    rstHeading "gnome-shell: system-monitor" section
    echo

    local _gitUrl="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet.git"
    local _folder="gnome-shell-system-monitor-applet"
    local _dst="${GNOME_SHELL_EXTENSIONS}/system-monitor@paradoxxx.zero.gmail.com"
    cloneGitRepository \
        "$_gitUrl" \
        "$_folder"
    rstBlock "install extension into $_dst"
    rm -rf "$_dst"
    cp -r "${CACHE}/${_folder}/system-monitor@paradoxxx.zero.gmail.com" "${GNOME_SHELL_EXTENSIONS}"
    waitKEY

    rstHeading "Deinstallation Unity"

    rstBlock "Es wurde der Gnome-Shell Desktop installiert. Der Desktop Unity
ist damit nicht weiter erforderlich. Unity kann mit allen seinen Komponenten
deinstalliert werden."

    remove_unity
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
