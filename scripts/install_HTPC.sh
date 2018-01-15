#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install kodi (xbmc) HTPC
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# hier gehts weiter ...

# Aktueller Stand: Man sollte sich zuerst das PPA installieren, danach das kodi
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

#KODI_PPA=ppa:team-xbmc/ppa
KODI_PPA=ppa:team-xbmc/unstable
#KODI_PPA=add-apt-repository ppa:team-xbmc/xbmc-nightly

BASE_PACKAGES="\
 kodi kodi-pvr-vdr-vnsi \
"

VDR_PACKAGES="\
  vdr vdr-plugin-vnsiserver \
"

XINE_PACKAGES="\
  xine-ui xine-plugin vdr-plugin-xine \
"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Installation HTPC (kodi)" part
# ----------------------------------------------------------------------------

    case $1 in

        kodi-ppa)
            rstHeading "Installation des kodi PPA"
            echo
            echo "Zuerst wird kodi deinstalliert"
            systemctl stop kodi
            aptPurgePackages kodi kodi-bin kodi-data
	    apt-get install software-properties-common
	    add-apt-repository $KODI_PPA
	    apt-get update
            ;;
        install-kodi)
            TITLE="Installation kodi (base)" aptInstallPackages ${BASE_PACKAGES}
            ;;
       	deinstall-kodi)
            systemctl start kodi
            TITLE="De-Installation kodi (base)" aptPurgePackages ${BASE_PACKAGES}
            ;;
        install-vdr)
            install_vdr
            ;;
       	deinstall-vdr)
            TITLE="De-Installation VDR" aptPurgePackages ${VDR_PACKAGES}
            ;;
        install-xine)
            TITLE="Installation xine (VDR)" aptInstallPackages ${XINE_PACKAGES}
            systemctl restart vdr.service
            ;;
       	deinstall-xine)
            TITLE="De-Installation xine (VDR)" aptPurgePackages ${XINE_PACKAGES}
            systemctl restart vdr.service
            ;;
        kodi-service)
            # http://kodi.wiki/view/HOW-TO:Autostart_Kodi_for_Linux#Add_a_new_systemd_script
            rstHeading "kodi wird als Services eingerichtet"
            rstBlock "Zuerst wird Benutzer 'kodi' eingerichtet"
            echo
            adduser --disabled-password --disabled-login --gecos "" kodi
            waitKEY
            TITLE="Installation xserver-xorg-legacy" aptInstallPackages xserver-xorg-legacy
            TEMPLATES_InstallOrMerge /etc/X11/Xwrapper.config root root 644
            rstBlock "Im folgenden Setup muss 'Jeder' aktiviert werden!"
            waitKEY
            dpkg-reconfigure xserver-xorg-legacy
            rstBlock "Nun wird der Dienst eingerichtet"
            TEMPLATES_InstallOrMerge /etc/systemd/system/kodi.service root root 644
            systemctl enable kodi.service
            systemctl start kodi.service
            systemctl status kodi.service
            ;;
        *)
            echo
	    echo "usage $0 [kodi-ppa|[de]install-[xine|kodi|vdr]|kodi-service]"
            echo
            ;;
    esac
}


# ----------------------------------------------------------------------------
install_vdr(){
# ----------------------------------------------------------------------------

    TITLE="Installation VDR" aptInstallPackages ${VDR_PACKAGES}

    # VDR Setup einrichten
    service vdr stop
    TEMPLATES_InstallOrMerge /etc/default/vdr root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/channels.conf root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/svdrphosts.conf root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/conf.d/00-vdr.conf  root root 644
    TEMPLATES_InstallOrMerge /etc/vdr/plugins/vnsiserver/allowed_hosts.conf root root 644

    # VDR als Dienst einrichten
    TEMPLATES_InstallOrMerge /lib/systemd/system/vdr.service root root 644

    # see /etc/vdr/conf.d/00-vdr.conf
    local vdr_folder=/share/video/vdr-recording

    rstBlock "Ordner für Videorecording: ${vdr_folder}"
    mkdir -p ${vdr_folder}
    chown vdr:video ${vdr_folder}
    ls -la ${vdr_folder}
    waitKEY

    dpkg-reconfigure vdr

    rstBlock "Es wird der VDR Server gestartet."
    systemctl restart vdr.service
    systemctl status vdr.service
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
