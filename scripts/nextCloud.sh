#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     nextCloud.sh
# -- Copyright (C) 2018 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     nextCloud
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

nextCloud_PACKAGES="\
 nextCloud-server nextCloud-client \
"

CONFIG_BACKUP=(
    "/etc/default/nextCloud"
)

CONFIG_BACKUP_ENCRYPTED=(
)


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------
    cat <<EOF

$1

usage:
  $(basename $0) install    server
  $(basename $0) remove     server
  $(basename $0) activate   server
  $(basename $0) deactivate server

EOF
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "nextCloud" part
# ----------------------------------------------------------------------------

    case $1 in
        install)
            sudoOrExit
            case $2 in
                server)  install_nextCloud_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                client)  remove_nextCloud_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  activate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}



# ----------------------------------------------------------------------------
install_nextCloud_server(){
    rstHeading "Installation nextCloud"
# ----------------------------------------------------------------------------

    source "${SCRIPT_FOLDER}/apache_setup.sh" --source-only

    rstBlock "Die Installation von nextCloud erfolgt hinter einem
WEB-Server.  Die nextCloud selber richtet man dann online ein, was nicht mehr
Teil dieses Skriptes ist.

Bei dieser Installation der nextCloud wird der Apache WEB Server
vorausgesetzt. Sofern der erforderliche WEB-Server und Komponenten nicht bereits
installiert sind, werden diese nun installiert.  Die Installation des Apache
Servers nutzt die Methoden und Skripte, die in den handsOn bereitstehen, mehr
dazu kann man unter [1] nachlesen.

[1] https://return42.github.io/handsOn/apache_setup/index.html"

    if ! aptPackageInstalled apache2 ; then
	rstBlock "Apache ist noch nicht installiert. Für die nextCloud
Installation wird nun eine Apache Installation eingerichtet ..."
	waitKEY
	installApachePackages
	serverwide_cfg
	mod_security2
    fi

    if ! aptPackageInstalled libapache2-mod-php ; then
	rstBlock "nextCloud ist eine PHP Anwendung. Das PHP-Modul für Apache ist
noch nicht installiert. Die Installation wird nun vorgenommen ..."
	waitKEY
	installPHP
    fi


    FIXME: .... nun die nextCloud Installation
}




# ----------------------------------------------------------------------------
activate_server () {
    rstHeading "Aktivieren des nextCloud (service)" section
# ----------------------------------------------------------------------------
    echo ""
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl enable nextCloud-server.service
systemctl restart nextCloud-server.service
EOF
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl status nextCloud-server.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server () {
    rstHeading "De-Aktivieren des nextCloud (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl stop nextCloud-server.service
systemctl disable nextCloud-server.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
remove_nextCloud_server() {
    rstHeading "De-Installation nextCloud"
# ----------------------------------------------------------------------------

    if ! askYn "Soll nextCloud deinstalliert werden?"; then
        return
    fi
    deactivate_server
    aptPurgePackages ${nextCloud_PACKAGES}
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
