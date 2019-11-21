#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     ufw.sh
# -- Copyright (C) 2019 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     Installation der :deb:`ufw` Firewall
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

UFW_APT_PACKAGES="ufw gufw"
UFW_SETUP=/etc/ufw

CONFIG_BACKUP=(
    "${UFW_SETUP}"
)

CONFIG_BACKUP_ENCRYPTED=(
)

# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) ufw  [install|remove]

EOF
}

arg2_unknown(){
    if [[ -z ${2} ]] ; then
	usage "${BRed}ERROR:${_color_Off} missing $1's argument"
    else
	usage "${BRed}ERROR:${_color_Off} unknown $1 argument: $2"
    fi
}

intro(){
    rstHeading "Firewall (ufw)" part
}

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
        # info) less "${REPO_ROOT}/docs/ufw.rst" ;;

        ufw)
            intro; sudoOrExit
            case $2 in
                install)  ufw_install ;;
                remove)   ufw_remove ;;
                *)        arg2_unknown "$1" "$2"; exit 42;;
            esac ;;

        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}

# ----------------------------------------------------------------------------
ufw_install(){
     rstHeading "Installation Firewall (ufw)"
# ----------------------------------------------------------------------------

    if ! askYn "Soll eine Firewall eingerichtet werden?"; then
        return 42
    fi

    TITLE='Installation erforderlicher Pakete' \
	 aptInstallPackages $UFW_APT_PACKAGES

    rstHeading "Konfiguration und Aktivierung" section

    TEE_stderr 0 <<EOF | bash | prefix_stdout
ufw limit ssh
ufw limit http
ufw limit https
ufw allow from fe80::/10
ufw allow from 127.0.0.0/8 ::1
ufw enable
EOF

    if askYn "Soll das Logging der Firewall aktiviert werden"; then
	ufw logging on
    else
	ufw logging off
    fi

    info_msg "\n  Die Firewall ist nun aktiv."

    echo -e "\nEs kann sein, dass einige Dienste nun nicht mehr oder nur
eingeschränkt funktionieren, weil sie durch die Firewall geblockt werden.
Ggf. müssen weitere UFW Regeln freigeschaltet werden, wie z.B. die
folgenden. die aber i.d.R. nur auf Severn im Intranet freischaltet werden
sollten(!)::

   sudo -H ufw allow CUPS
   sudo -H ufw allow ldaps

Um expliziet Samba für IPv4 im Intranet frei zu schalten könnte man
konfigurieren:

   sudo -H ufw allow from 192.168.0.0/16 port '137,138' proto 'udp'
   sudo -H ufw allow from 192.168.0.0/16 port '139,445' proto 'tcp'

Alternati kann man auch alle Zugriffe in/aus dem Intranet frei schalten (siehe
unten).  Beispiele für weitere Dienste die auf diesem Host installiert sind:"

    TEE_stderr 1 <<EOF | bash | prefix_stdout
ufw app list
ufw app info CUPS
EOF

    if askNy "Soll die Firewall für Zugriffe aus dem Intranet inaktiv sein?"; then
	local subnetz
	ask subnetz "IPv4 Subnetz-Mask, z.B. 192.168.1.0/16 oder - um abzubrechen" "-"
	if [[ ! $subnetz == "-" ]]; then
	    TEE_stderr 1 <<EOF | bash | prefix_stdout
ufw allow from fd00::/8
ufw allow from $subnetz
EOF
	fi
    fi

    ufw status verbose
    rstBlock "Die Firewall kann auch über eine GUI 'gufw' Verwaltet werden."
    waitKEY
}

# ----------------------------------------------------------------------------
ufw_remove() {
    rstHeading "De-Installation Firewall"
# ----------------------------------------------------------------------------
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
sudo -H ufw disable
EOF
    if ! askNy "Firewall wurde deaktiviert.  Soll wirklich noch deinstalliert werden?"; then
        return
    fi
    aptPurgePackages $UFW_APT_PACKAGES
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
