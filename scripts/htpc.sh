#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install kodi (xbmc) HTPC
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# hier gehts weiter ...
# https://projects.vdr-developer.org/projects/plg-streamdev
# https://projects.vdr-developer.org/projects/mpv-vdr-streamdev-client/wiki
# file:///usr/share/doc/mpv/mpv.html


# Aktueller Stand:
# Ubuntu 18.04:: inzwischen gibt es auch die PPAs
# Ubuntu 16.04:: Man sollte sich zuerst das PPA installieren, danach das kodi
# aus dem PPA installieren. Für VDR und Live TV sollte man dann die
# $VDR_PACKAGES installieren. Danach VDR Server neu starten.
#
# Mit LiveTV hatte ich erhebliche Probleme:
#
# Um Problemen mit unterschiedlichen kodi Versionen aus dem Weg zu gehen, hab
# ich erst mal ~/.kodi gelöscht bevor ich kodi gestartet hab. Danach musste ich
# unter "System->Settings->Add-ons->My add-ons->PVR Clients->VDR VNSI CLient"
# aktivieren, danach "System->TV->Genreal: Enabled" aktivieren. Danach am besten
# das kodi erst mal neu starten (irgendwie spinnt das bei mir).
#
# VDR log:   $ tail -f /var/log/syslog
# kodi log:  $ tail -f  /home/user/.kodi/temp/kodi.log
#
# Siehe auch:
#
#  * https://www.loggn.de/all-in-one-howto-ubuntu-10-04-installation-konfiguration-von-nvidia-vdpau-vdr-mit-vnsi-server-xbmc-pvr-testing2/
#
# Kodi:
#
# * Tastaturbelegung: http://kodi.wiki/view/Keyboard
# * KeyMap Editor (IR): http://kodi.wiki/view/Add-on:Keymap_Editor
#
# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

KODI_PACKAGES="\
 kodi kodi-pvr-vdr-vnsi \
"

KODI_PPA="ppa:team-xbmc/ppa"
#KODI_PPA="ppa:team-xbmc/unstable"
#KODI_PPA="ppa:team-xbmc/xbmc-nightly"

MPV_PACKAGES="\
 mpv \
"

# https://launchpad.net/~mc3man/+archive/ubuntu/mpv-tests
MPV_PPA="ppa:mc3man/mpv-tests"

VDR_PACKAGES="\
 vdr\
 vdr-plugin-vnsiserver\
 vdr-plugin-streamdev-server\
 vdr-plugin-vdrmanager
"
VDR_PPA=ppa:yavdr/stable-vdr

XINE_PACKAGES="\
  xine-ui xine-plugin vdr-plugin-xine \
"


usage(){
    cat <<EOF
usage: $(basename $0) [install|deinstall|info] [kodi|vdr|mpv]
EOF
}

main(){

    case $1 in

        install)
            sudoOrExit
	    apt-get -q install software-properties-common 2>/dev/null 1>/dev/null
            case $2 in
                kodi) install_kodi
                      ;;
                mpv) install_mpv
                      ;;
                vdr) install_vdr
                      ;;
                *) usage; exit 42
                   ;;
            esac
            ;;
        deinstall)
            sudoOrExit
	    apt-get -q install software-properties-common 2>/dev/null 1>/dev/null
            case $2 in
                kodi) deinstall_kodi
                      ;;
                mpv) deinstall_mpv
                      ;;
                vdr) deinstall_vdr
                      ;;
                *) usage; exit 42
                   ;;
            esac
            ;;
        info)
            case $2 in
                kodi) rstHeading "Kodi (PPA)"; info_kodi
                      ;;
                mpv) rstHeading "MPV (PPA)"; info_mpv
                      ;;
                vdr) rstHeading "VDR (PPA)"; info_vdr
                      ;;
                *) rstHeading "Infos zu den HTPC Komponenten"
                   info_kodi
                   info_mpv
                   info_vdr
                   ;;
            esac
            ;;
        custom)
            case $2 in
                kodi) custom_kodi
                      ;;
                mpv) custom_mpv
                      ;;
                vdr) custom_vdr
                      ;;
                *) custom_kodi
                   custom_mpv
                   custom_vdr
                   ;;
            esac
            ;;

        # install-xine)
        #     TITLE="Installation xine (VDR)" aptInstallPackages ${XINE_PACKAGES}
        #     systemctl restart vdr.service
        #     ;;
       	# deinstall-xine)
        #     TITLE="De-Installation xine (VDR)" aptPurgePackages ${XINE_PACKAGES}
        #     systemctl restart vdr.service
        #     ;;
        # kodi-service)
        #     # http://kodi.wiki/view/HOW-TO:Autostart_Kodi_for_Linux#Add_a_new_systemd_script
        #     rstHeading "kodi wird als Services eingerichtet"
        #     rstBlock "Zuerst wird Benutzer 'kodi' eingerichtet"
        #     echo
        #     adduser --disabled-password --disabled-login --gecos "" kodi
        #     waitKEY
        #     TITLE="Installation xserver-xorg-legacy" aptInstallPackages xserver-xorg-legacy
        #     TEMPLATES_InstallOrMerge /etc/X11/Xwrapper.config root root 644
        #     rstBlock "Im folgenden Setup muss 'Jeder' aktiviert werden!"
        #     waitKEY
        #     dpkg-reconfigure xserver-xorg-legacy
        #     rstBlock "Nun wird der Dienst eingerichtet"
        #     TEMPLATES_InstallOrMerge /etc/systemd/system/kodi.service root root 644
        #     systemctl enable kodi.service
        #     systemctl start kodi.service
        #     systemctl status kodi.service
        #     ;;
        *)
            usage
            ;;
    esac
}

# ----------------------------------------------------------------------------
# Kodi
# ----------------------------------------------------------------------------

info_kodi(){
    rstBlock "\
Die Kodi Instanz aus den LTE Distributionen ist z.T. hoffnungslos veraltet und
sollte -- falls bereits installiert -- zuerst deinstalliert werden.  Eine
aktuelle Version des Kodi wird am besten aus dem PPA ($KODI_PPA) installiert."
}

install_kodi(){

    rstHeading "Kodi (PPA)"
    info_kodi
    waitKEY 10

    deinstall_kodi

    rstHeading "Füge PPA hinzu" section
    echo
    add-apt-repository -y $KODI_PPA
    apt-get update

    TITLE="Installation Kodi (base)" \
	 aptInstallPackages ${KODI_PACKAGES}

    # TITLE="Installation Voraussetzungen" \
    #	 aptInstallPackages software-properties-common snap

    # rstHeading "snap kodi (edge)" section
    # echo
    # snap install kodi --edge

}

deinstall_kodi(){

    rstHeading "uninstall Kodi" section
    echo
    systemctl stop kodi 2>&1  > /dev/null

    TITLE="De-Installation kodi (base)" \
	 aptPurgePackages 'kodi-.*' ${KODI_PACKAGES}

    rstHeading "Entferne PPA" section
    echo
    add-apt-repository -y --remove $KODI_PPA
    # Falls über snap installiert wurde (aus der Übergangszeit als es kein PPA
    # gab)
    snap remove kodi

}

custom_kodi(){
    echo "# KODI setup: a list of Kodi's customized system files"
    cat <<EOF
# none system config files, there is only ~/.kodi folder
EOF
}

# ----------------------------------------------------------------------------
# MPV
# ----------------------------------------------------------------------------

info_mpv(){
    rstBlock "\
Die MPV Instanz aus den LTE Distributionen ist hoffnungslos veraltet
und sollte -- falls bereits installiert -- zuerst deinstalliert werden.
Eine aktuelle Version des MPV kann dann aus dem PPA ($MPV_PPA)
installiert werden.
"
}

install_mpv(){
    rstHeading "MPV (PPA)"
    info_mpv
    waitKEY 10

    deinstall_mpv

    rstHeading "Füge PPA hinzu" section
    echo
    add-apt-repository -y $MPV_PPA
    apt-get update
    TITLE="Installation MPV" \
	 aptInstallPackages ${MPV_PACKAGES}
}

deinstall_mpv(){
    rstHeading "uninstall MPV" section
    echo
    TITLE="De-Installation MPV" \
	 aptPurgePackages ${MPV_PACKAGES}
    rstHeading "Entferne PPA" section
    echo
    add-apt-repository -y --remove $MPV_PPA
}

custom_mpv(){
    echo "# MPV setup: a list of MPV's customized files"
    cat <<EOF
/etc/mpv/encoding-profiles.conf
EOF
}


# ----------------------------------------------------------------------------
# VDR
# ----------------------------------------------------------------------------

info_vdr(){
    rstBlock "\
Die VDR Instanz aus den LTE Distributionen ist hoffnungslos veraltet
und sollte -- falls bereits installiert -- zuerst deinstalliert werden.
Eine aktuelle Version des VDR kann dann aus dem PPA ($VDR_PPA)
installiert werden."
}

install_vdr(){

    rstHeading "VDR (PPA)"
    info_vdr
    waitKEY 10

    service vdr stop 2>&1  > /dev/null
    aptPurgePackages 'vdr-.*'
    apt-get install software-properties-common

    rstHeading "Füge PPA hinzu" section
    echo
    add-apt-repository $VDR_PPA
    apt-get update
    TITLE="Installation VDR" aptInstallPackages ${VDR_PACKAGES}

    # VDR Setup einrichten
    service vdr stop
    TEMPLATES_InstallOrMerge /etc/default/vdr root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/channels.conf root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/svdrphosts.conf root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/conf.d/00-vdr.conf  root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/plugins/vnsiserver/allowed_hosts.conf root root 644

    # VDR als Dienst einrichten
    TEMPLATES_InstallOrMerge /etc/systemd/system/vdr.service root root 644

    # see /etc/vdr/conf.d/00-vdr.conf
    local vdr_folder=/share/video/vdr-recording

    rstBlock "Ordner für Videorecording: ${vdr_folder}"
    mkdir -p ${vdr_folder}
    chown vdr:video ${vdr_folder}
    ls -la ${vdr_folder}
    waitKEY

    dpkg-reconfigure vdr

    rstBlock "Es wird der VDR Server gestartet."
    systemctl enable vdr.service
    systemctl restart vdr.service
    systemctl status vdr.service
}

deinstall_vdr(){

    systemctl stop vdr 2>&1  > /dev/null
    TITLE="De-Installation VDR" aptPurgePackages ${VDR_PACKAGES}
    rstHeading "Entferne PPA" section
    echo
    add-apt-repository --remove $VDR_PPA
}

custom_vdr(){
    cat <<EOF
# VDR setup: a list of VDR's customized system files"
/etc/default/vdr
/etc/vdr/channels.conf
/etc/vdr/svdrphosts.conf
/etc/vdr/conf.d/00-vdr.conf
/etc/vdr/plugins/vnsiserver/allowed_hosts.conf
/etc/systemd/system/vdr.service
EOF
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
