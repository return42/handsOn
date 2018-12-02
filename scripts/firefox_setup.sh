#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     firefox_addons.sh
# -- Copyright (C) 2018 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     FFox Setup
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

DEB_PCKG="firefox firefox-locale-de"

MOZILLA_XPI_URL=(

    # Startpage.com
    # FIXME: wird derzeit (Dez.2018) noch nicht im FFox angezeigt, warum?
    "https://addons.mozilla.org/firefox/downloads/file/839942/startpagecom.xpi"

    # DuckDuckGo
    "https://addons.mozilla.org/firefox/downloads/file/1122630/duckduckgo_privacy_essentials.xpi"

    # Privacy Possum by cowlicks
    # zuletzt verifiziert: 20181005
    # Homepage: https://github.com/cowlicks/privacypossum
    #           https://addons.mozilla.org/de/firefox/addon/privacy-possum/
    "https://addons.mozilla.org/firefox/downloads/latest/privacy-possum/addon-1062944-latest.xpi"

    # CanvasBlocker
    # zuletzt verifiziert: 20181005
    # Homepage: https://github.com/kkapsner/CanvasBlocker/
    #           https://addons.mozilla.org/de/firefox/addon/canvasblocker/
    # https://addons.mozilla.org/firefox/downloads/file/1086424/canvasblocker-0.5.4-an+fx.xpi?src=dp-btn-primary
    "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-1086424-latest.xpi"

    # Decentraleyes
    # zuletzt verifiziert: 20181005
    # Homepage: https://decentraleyes.org/
    #           https://addons.mozilla.org/de/firefox/addon/decentraleyes/
    # "https://addons.mozilla.org/firefox/downloads/file/1078499/decentraleyes-2.0.8-an+fx.xpi?src=dp-btn-primary"
    "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/addon-1078499-latest.xpi"

    # disconnect
    # wird nicht mehr gepflegt / einen Ersatz braucht man nicht
    # "https://addons.mozilla.org/firefox/downloads/latest/disconnect/platform:2/addon-464050-latest.xpi"

    # Dict.cc Translation
    # zuletzt verifiziert: 20181005
    "https://addons.mozilla.org/firefox/downloads/latest/dictcc-translation/platform:2/addon-15095-latest.xpi"

    # Google search link fix
    # zuletzt verifiziert: 20181005
    # https://addons.mozilla.org/de/firefox/addon/google-search-link-fix
    "https://addons.mozilla.org/firefox/downloads/latest/google-search-link-fix/addon-351740-latest.xpi"

    # Privacy Settings
    # FIXME: könnte immernoch ganz praktisch sein .. aber braucht man das immernoch?
    # https://addons.mozilla.org/de/firefox/addon/privacy-settings
    "https://addons.mozilla.org/firefox/downloads/latest/privacy-settings/addon-627512-latest.xpi"

    # Disable Hello, Pocket & Reader+
    # https://addons.mozilla.org/en-US/firefox/addon/disable-hello-pocket-reader
    #"https://addons.mozilla.org/firefox/downloads/latest/620266/addon-620266-latest.xpi?src=search"

    # "uBlock origin" https://github.com/gorhill/uBlock
    # zuletzt verifiziert: 20181005
    # "Adblock Plus" ist sch..., "Adblock Edge" wird nicht mehr weiter entwickelt.
    "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi"

    # sqlite-manager http://lazierthanthou.github.io/sqlite-manager/
    # Besser ist das Paket "sudo apt-get instal sqlitebrowser"
    # "https://addons.mozilla.org/firefox/downloads/latest/5817/addon-5817-latest.xpi"

)


# ----------------------------------------------------------------------------
main(){
    rstHeading "Firefox AddOns, sysPrefs & Tor-Browser" part
# ----------------------------------------------------------------------------

    sudoOrExit

    case $1 in
	install)
	    aptInstallPackages ${DEB_PCKG}
            installFFSysPrefs
	    installFFAddOns
	    installTorBrowser
	    ;;
	deinstall)
	    deinstallFFAddOns
	    deinstallTorBrowser
            apt-get autoremove -y
            apt-get clean
	    ;;
        update)
            installFFAddOns
            ;;
	*)
            echo
	    echo "usage $0 [install|deinstall|update]"
            echo
            ;;
    esac
}


# ----------------------------------------------------------------------------
installFFSysPrefs(){
# ----------------------------------------------------------------------------

    rstHeading "Setup der globalen Firefox-Einstellungen" section

    echo -e "
Es werden die systemweiten *Preferences* des Firefox gesetzt. Eine Beschreibung
hierzu findet man unter:

* https://developer.mozilla.org/en-US/docs/Mozilla/Preferences

* https://developer.mozilla.org/de/Firefox/Nutzung_in_Unternehmen

Der Link /usr/lib/firefox/browser/defaults/preferences/ zeigt auf
/etc/firefox/syspref.js siehe auch:

* https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences#Modifying_preferences"
    rstHeading "System Einstellungen" section
    echo
    TEMPLATES_InstallOrMerge /etc/firefox/syspref.js root root 644
    waitKEY

    rstHeading "Handling der apt-URLs" section
    err_msg "FIXME: Datei /etc/firefox/pref/apturl.js wird scheinbar gar nicht mehr vom FFox gelesen"
    err_msg "FIXME: ... funktioniert deshalb nicht mehr !!! ..."
    waitKEY
    TEMPLATES_InstallOrMerge /etc/firefox/pref/apturl.js root root 644
    waitKEY
}

# ----------------------------------------------------------------------------
installFFAddOns(){
# ----------------------------------------------------------------------------

    rstHeading "Installation der globalen Firefox-AddOns" chapter

    echo -e "
Die Installation der globalen Erweiterungen erfolgt in den Ordner::

  ${FFOX_GLOBAL_EXTENSIONS}

Siehe auch:

- http://kb.mozillazine.org/Installation_directory

- http://return42.github.io/handsOn/excursion/search_engines.html

Die Benutzer finden die globalen AddOns in ihren Eintsellungen des Firefox
wieder.  Dort können sie die AddOns nach belieben aktivieren oder deaktivieren.
Eine Deinstallation ist für die Anwender nicht möglich.

${BRed}.. hint::

   Die Benutzer müssen die AddOns einmal deaktivieren und dann wieder
   aktivieren.  Dann hat man auch die Icons in der Werkzeugleiste.

   Die AddOns sollten hier nun folgend nicht aus dem Cache installiert werden,
   wenn man sie updaten will (logisch).${_color_Off}"

    waitKEY 20

    for xpi_url in "${MOZILLA_XPI_URL[@]}"; do

        # extrahieren des Dateinamens aus der URL

        xpi_fname=${xpi_url##*/}
        xpi_fname=firefox_${xpi_fname%%\?*}

        rstHeading "${xpi_fname}" section
        echo
        cacheDownload "${xpi_url}" "${xpi_fname}" askNy
        FFOX_globalAddOn install ${CACHE}/${xpi_fname}
    done
    waitKEY 20
}

# ----------------------------------------------------------------------------
deinstallFFAddOns(){
# ----------------------------------------------------------------------------

    rstHeading "De-Installation der globalen Firefox-AddOns" section

    rstBlock "Die Installation der globalen Erweiterungen erfolgt

  ${Yellow}Um die UIDs der AddOns zu ermitteln müssen die AddOns im Cache
  sein. Sind sie das nicht, müssen sie (leider) erst aus dem Netzt geladen
  werden${_color_Off}"

    for xpi_url in "${MOZILLA_XPI_URL[@]}"; do

        # extrahieren des Dateinamens aus der URL

        xpi_fname=${xpi_url##*/}
        xpi_fname=firefox_${xpi_fname%%\?*}

        rstHeading "${xpi_fname}" section
        echo
        cacheDownload "${xpi_url}" "${xpi_fname}"
        FFOX_globalAddOn deinstall ${CACHE}/${xpi_fname}
    done
    waitKEY 20
}


# ----------------------------------------------------------------------------
installTorBrowser(){
    rstHeading "Tor-Browser (launcher)"
# ----------------------------------------------------------------------------

    rstBlock "Der Tor-Browser muss von jedem Anwender selber installiert werden. Um
dies komfortabel zu ermöglichen gibt es das Paket 'torbrowser-launcher' welches
nun installiert wird.

Die Installation wird vom Benutzer angestossen sobald dieser erstmalig den
Browser (Launcher) aufruft.

  $ torbrowser-launcher"

    if askYn "soll der launcher installiert werden?"; then
        if  [[ $(echo "$DISTRIB_RELEASE > 14.04" | bc) ]]; then
	    # Ab 14.10 soll das ppa (resp. torbrowser-launcher) im Standard sein
	    add-apt-repository -y ppa:micahflee/ppa
	    apt-get update
        fi
        apt-get install -y torbrowser-launcher
    fi
    waitKEY 20
}

# ----------------------------------------------------------------------------
deinstallTorBrowser(){
    rstHeading "Deinstallation Tor-Browser (launcher)"
# ----------------------------------------------------------------------------

    # zuletzt verifiziert: 20181005
    echo
    apt-get remove -y --purge torbrowser-launcher
    waitKEY 20
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------

