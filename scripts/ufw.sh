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

  $(basename $0) [install|remove|config] ufw

install: Installiert die UFW mit minamalen Freigaben (z.B. ssh)
remove: Deaktivierung und Deinstallation der UFW Firewall
config: Freischalten der Dienste für das Intranet
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

        install)
            intro; sudoOrExit
            case $2 in
                ufw)  ufw_install ;;
                *) arg2_unknown "$1" "$2"; exit 42 ;;
            esac ;;
        remove)
            intro; sudoOrExit
            case $2 in
                ufw) ufw_remove ;;
                *) arg2_unknown "$1" "$2"; exit 42 ;;
            esac ;;
        config)
            intro; sudoOrExit
            case $2 in
                ufw)
                    ufw_setloglevel
                    ufw_intranet
                    ;;
                *) arg2_unknown "$1" "$2"; exit 42;;
            esac ;;

        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}

# ----------------------------------------------------------------------------
ufw_install(){
     rstHeading "Installation Firewall (ufw)"
# ----------------------------------------------------------------------------

    local loglev

    if ! askYn "Soll eine Firewall eingerichtet werden?"; then
        return 42
    fi

    TITLE='Installation erforderlicher Pakete' \
	 aptInstallPackages $UFW_APT_PACKAGES

    rstBlock "Sicherstellen, dass man sich nicht den eigenen ssh Zugang blockiert:"
    TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw limit ssh comment 'at max 5 connects in 30sec'
EOF
    waitKEY

    ufw_setloglevel

    rstHeading "Konfiguration und Aktivierung" section
    echo
    TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw allow http
ufw allow https
ufw allow from 127.0.0.0/8             comment 'IPv4 loopback device'
ufw allow from ::1                     comment 'IPv6 loopback device'
ufw allow from fe80::/10               comment 'IPv6 link local'
ufw allow proto udp to 224.0.0.0/4     comment 'IPv4 Multicast'
ufw --force enable
EOF

    info_msg "Die Firewall ist aktiv!"
    rstBlock "Die Firewall kann auch über eine GUI (gufw) verwaltet werden."
    waitKEY
    ufw_intranet
}

# ----------------------------------------------------------------------------
ufw_intranet(){
# ----------------------------------------------------------------------------
    rstHeading "Freischalten der Dienste im Intranet"

    rstBlock "Es kann sein, dass einige Dienste nun nicht mehr oder nur
eingeschränkt funktionieren, weil sie durch die Firewall geblockt werden.
Derzeit sind folgende Regel eingestellt.
"
    bash <<EOF | prefix_stdout
ufw status verbose
EOF
    waitKEY
    echo -e "Ggf. müssen weitere UFW Regeln zum Freischalten gesetzt werden, wie
z.B. die folgenden, die aber nur für Zugriffe aus dem Intranet (192.168.??.??)
freigeschaltet werden sollten(!)::

   sudo -H ufw allow from 192.168.??.0/24 to any app 'OpenLDAP LDAPS'
   sudo -H ufw allow from 192.168.??.0/24 to any app 'CUPS'

Alternativ kann man auch alle Zugriffe in/aus dem Intranet frei schalten (siehe
unten).  Beispiele für weitere Dienste, die auf diesem Host installiert sind:
"
    TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw app list
ufw app info CUPS
EOF
    waitKEY

    rstBlock "Bitte wählen, ob die Firewall für Zugriffe aus Intranet komplett
inaktiv sein soll oder ob die Ports zu einzelnen Diensten interaktiv
freigeschaltet werden sollen."

    local ipv4mask
    local action
    chooseOneMenu action "Auswahl:" \
           "Nichts ändern." \
           "Einzelne Dienste freischalten." \
           "Komplett dekativieren."

    case $action in
        "Nichts ändern.") ;;
        "Komplett dekativieren.")
            askIPv4Netmask ipv4mask
	    TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw allow from fd00::/8   comment "subnet (unique local)"
ufw allow from $ipv4mask  comment "subnet (netmask)"
EOF
            ;;
        "Einzelne Dienste freischalten.")
            askIPv4Netmask ipv4mask
            local service
            for service in 'Apache Secure' \
                           'Dovecot Secure IMAP' \
                           'Dovecot Secure POP3' \
                           'OpenLDAP LDAPS' \
                           'OpenSSH' \
                           'Postfix SMTPS' \
                           'Samba' ; do
                if askYn "Ports für Dienst ${BYellow}$service${_color_Off} im Intranet freigegeben?"; then
                   TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw allow from fd00::/8 to any app "$service"  comment "subnet (unique local)"
ufw allow from $ipv4mask to any app "$service" comment "subnet (netmask)"
EOF
                fi
            done
            ;;
        *) err_msg "unknown item selected" ;;
    esac

    rstBlock "aktualisierte Regeln ..."
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
ufw status
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
ufw_setloglevel(){
# ----------------------------------------------------------------------------
    rstHeading "Logging der Firewall" section
    echo
    chooseOneMenu loglevel "Log-Level auswählen:" low off medium high full
    TEE_stderr 0.2 <<EOF | bash | prefix_stdout
ufw logging $loglevel
EOF
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
