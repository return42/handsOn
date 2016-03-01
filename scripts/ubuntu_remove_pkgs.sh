#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     nnn_remove_pkgs.sh
# -- Copyright (C) 2014 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     bootstrap des STORAGE Servers
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# unity-webapps-common / xul-ext* ::
# -------------------------------
#
# Dieser ganze Unity Kram ist nur buggy. Z.B. die xul Erweiterungen für den
# Firefox, die sind schon seit seit 2012 fehlerhaft und man hat auch nur bis
# 2015 gebraucht um den Bug zu fixen (3Jahre hat mich das genervt).
#
# https://bugs.launchpad.net/ubuntu/+source/unity-firefox-extension/+bug/1069793
#
# ureadahead
# ----------
#
# Scheint seit 12.04 buggy und müllt das syslog voll. Wird seit 2010 nicht mehr
# gepflegt und aktuell 27 offene Bugs ... wieso hat man so einen Schrott in
# seiner Distro?
#
# * https://bugs.launchpad.net/ubuntu/+source/ureadahead

REMOVE_PACKAGES_UBUNTU="\
 unity-webapps-common \
 ureadahead \
 whoopsie \
 $(dpkg-query -f '${binary:Package} ' -W 'xul-ext*') \
 flashplugin-installer \
 evolution-data-server-online-accounts \
"

COMERCIAL_PACKAGES="\
 software-center app-install-data \
"
GNOME_ACCOUNT_PLUGINS="\
  $(dpkg-query -f '${binary:Package} ' -W 'account-plugin*')
"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Entfernen zweifelhafter Pakete" part
# ----------------------------------------------------------------------------

    sudoOrExit
    common_ubuntu
    commercial
    gnomeAccounts
    apt-get autoremove -y

}

# ----------------------------------------------------------------------------
common_ubuntu(){
# ----------------------------------------------------------------------------

    rstHeading "Ubuntu typische Pakete"
    rstPkgList ${REMOVE_PACKAGES_UBUNTU}
    if askYn "Sollen die Pakete deinstalliert werden?" ; then
        apt-get purge --ignore-missing -y ${REMOVE_PACKAGES_UBUNTU}
        # die Whoopsie ID muss man expliziet löschen
        rm -f /var/lib/whoopsie/whoopsie-id
    fi
    waitKEY 20
}

# ----------------------------------------------------------------------------
commercial(){
# ----------------------------------------------------------------------------

    rstHeading "Kommerzielle Pakete"
    rstPkgList ${COMERCIAL_PACKAGES}
    if askYn "Sollen die Pakete deinstalliert werden?" ; then
        apt-get purge --ignore-missing -y ${COMERCIAL_PACKAGES}
    fi

    # FIXME: die ganzen searchengines sind in den language-packs gebundelt:
    #        /usr/lib/firefox-addons/extensions/langpack-de@firefox.mozilla.org.xpi
    # und dann liegen sie auch nochmal hier rum::
    rm /usr/lib/firefox/distribution/searchplugins/locale/*/amazondotcom*.xml
    waitKEY 20
}

# ----------------------------------------------------------------------------
gnomeAccounts(){
# ----------------------------------------------------------------------------

    rstHeading "Online-Konten-Verwaltung (gnome)"
    rstPkgList ${GNOME_ACCOUNT_PLUGINS}
    if askYn "Sollen die Pakete deinstalliert werden?" ; then
        apt-get purge --ignore-missing -y ${GNOME_ACCOUNT_PLUGINS}
    fi
    waitKEY 20
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
