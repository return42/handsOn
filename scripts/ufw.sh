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

    if askYn "Soll das Logging der Firewall aktiviert werden"; then
	ufw logging on
    else
	ufw logging off
    fi


    TEE_stderr 1 <<EOF | bash | prefix_stdout
ufw allow ssh
ufw allow https
ufw allow http
ufw enable
ufw status verbose
EOF

    rstBlock "Die Firewall ist nun aktiv.  Es kann sein, dass einige Dienste nun
nicht mehr oder nur eingeschränkt funktionieren, weil sie durch die Firewall
geblockt werden.  Ggf. müssen weitere UFW Regeln freigeschaltet werden, wie
z.B. die folgenden. die aber i.d.R. nur auf Severn im Intranet freischaltet
werden sollten(!)::

   sudo -H ufw allow CUPS
   sudo -H ufw allow ldaps
   sudo -H ufw allow Samba

Beispiele für weitere Dienste:"
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ufw app list
ufw app info CUPS
EOF
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
    if ! askYn "Firewall wurde deaktiviert.  Soll wirklich noch deinstalliert werden?"; then
        return
    fi
    aptPurgePackages $UFW_APT_PACKAGES
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
