#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     firefox_addons.sh
# -- Copyright (C) 2019 darmarIT --  Author:   Markus Heiser
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
    # FIXME:  wird derzeit (Jan. 2019) noch nicht im FFox angezeigt, warum?
    "https://addons.mozilla.org/firefox/downloads/latest/1180731/startpagecom/addon-1180731-latest.xpi"

    # DuckDuckGo
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/duckduckgo/duckduckgo-privacy-extension
    #           https://addons.mozilla.org/de/firefox/addon/duckduckgo-for-firefox/
     "https://addons.mozilla.org/firefox/downloads/file/1000998/duckduckgo_privacy_essentials.xpi"

    # Privacy Possum by cowlicks
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/cowlicks/privacypossum
    #           https://addons.mozilla.org/de/firefox/addon/privacy-possum/
    "https://addons.mozilla.org/firefox/downloads/latest/privacy-possum/addon-1062944-latest.xpi"

    # CanvasBlocker
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/kkapsner/CanvasBlocker/
    #           https://addons.mozilla.org/de/firefox/addon/canvasblocker/
    # https://addons.mozilla.org/firefox/downloads/file/1086424/canvasblocker-0.5.4-an+fx.xpi?src=dp-btn-primary
    "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-1086424-latest.xpi"

    # Decentraleyes
    # zuletzt verifiziert: 20190129
    # Homepage: https://decentraleyes.org/
    #           https://addons.mozilla.org/de/firefox/addon/decentraleyes/
    # "https://addons.mozilla.org/firefox/downloads/file/1078499/decentraleyes-2.0.8-an+fx.xpi?src=dp-btn-primary"
    "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/addon-1078499-latest.xpi"

    # Dict.cc Translation
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/Lusito/dict.cc-translation
    #           https://addons.mozilla.org/de/firefox/addon/dictcc-translation/
    "https://addons.mozilla.org/firefox/downloads/latest/dictcc-translation/platform:2/addon-15095-latest.xpi"

    # Google search link fix
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/palant/searchlinkfix
    #           https://addons.mozilla.org/de/firefox/addon/google-search-link-fix
    "https://addons.mozilla.org/firefox/downloads/latest/google-search-link-fix/addon-351740-latest.xpi"

    # Privacy Settings
    # FIXME: könnte immernoch ganz praktisch sein .. aber braucht man das immernoch?
    # Homepage: https://add0n.com/privacy-settings.html
    #           https://addons.mozilla.org/de/firefox/addon/privacy-settings
    "https://addons.mozilla.org/firefox/downloads/latest/privacy-settings/addon-627512-latest.xpi"

    # Disable Hello, Pocket & Reader+
    # https://addons.mozilla.org/en-US/firefox/addon/disable-hello-pocket-reader
    #"https://addons.mozilla.org/firefox/downloads/latest/620266/addon-620266-latest.xpi?src=search"

    # "uBlock origin"
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/gorhill/uBlock
    #           https://addons.mozilla.org/de/firefox/addon/ublock-origin/
    "https://addons.mozilla.org/firefox/downloads/latest/607454/ublock-origin/addon-607454-latest.xpi"

    # SQLite Manager
    # zuletzt verifiziert: 20190129
    # Homepage: https://github.com/lunu-bounir/sqlite-manager/
    #           https://addons.mozilla.org/de/firefox/addon/sqlite-manager-webext/
    # Als Alternative zu einem PlugIn bietet sich auch das Paket ... an::
    #           sudo -H apt-get install sqlitebrowser"
    "https://addons.mozilla.org/firefox/downloads/latest/1157859/sqlite_manager/addon-1157859-latest.xpi"
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
            installFFSysPrefs
            installFFAddOns
            ;;
	*)
	    usage
            ;;
    esac
}


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:  $(basename $0) [install|deinstall|update]

 install:   install (all) FFox packages, addons, sysprefs.js
 deinstall: deinstall (all) FFox packages, addons, sysprefs.js
 update:    update addons and sysprefs.js

EOF
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

    rstBlock "Über eine globale /etc/firefox/syspref.js können (kritische?)
Funktionen des FFox abgeschaltet werden.  Einfach alles abschalten ist aber auch
keine brauchbare Lösung, da dann die meisten (pseudo) moderenen WEB-Seiten nicht
mehr funktionieren würden.  In den handsOn ist eine vorkonfektionierte
sysprefs.js enthalten, die sich aber noch in der Erprobungsphase befindet.  Wenn
man sich die installiert und später Probleme bemerkt, kann man diese einfach
löschen::

  sudo -H rm /etc/firefox/syspref.js"
    if askNy "Soll die /etc/firefox/syspref.js installiert werden?"; then
	TEMPLATES_InstallOrMerge /etc/firefox/syspref.js root root 644
    elif [ -f /etc/firefox/syspref.js ]; then
	if askNy "Soll die bestehende /etc/firefox/syspref.js entfernt werden?"; then
	    rm /etc/firefox/syspref.js
	fi
    fi

    rstHeading "Handling der apt-URLs" section

    rstBlock "Die Behandlung der APT URLs (apt://PAKETNAME) wird über die
URL-Handler Konfigration im FFox eingestellt (siehe about:preferences).  Früher
wurde das über eine Datei /etc/firefox/pref/apturl.js konfiguriert.  Diese Datei
wird auch nach wie vor (ubu1904) von dem Paket 'apturl-common' installiert,
allerdings schon seit längerem (2016?) nicht mehr vom FFox ausgewertet."
    # TEMPLATES_InstallOrMerge /etc/firefox/pref/apturl.js root root 644
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

    # zuletzt verifiziert: 20190129
    echo
    apt-get remove -y --purge torbrowser-launcher
    waitKEY 20
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------

