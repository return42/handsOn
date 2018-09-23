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
source "${SCRIPT_FOLDER}/apache_setup.sh" --source-only

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# In den Installationsanleitungen zur nextCloud wird aktuell (09/2018) noch das
# Paket php-mcrypt aufgeführt:
#
# - https://github.com/nextcloud/user_saml/pull/236
# - https://github.com/nextcloud/user_saml/issues/168

NEXTCLOUD_PACKAGES="\
 libapache2-mod-php \
 php-gd php-json php-mysql \
 php-curl php-mbstring php-intl \
 php-imagick php-xml php-zip \
"

MARIADB_PACKAGES="\
    mariadb-server
"

CONFIG_BACKUP=(
    "${APACHE_SITES_AVAILABE}/${NEXTCLOUD_APACHE_SITE}.conf"
    # ??? "/etc/default/nextCloud"
)

CONFIG_BACKUP_ENCRYPTED=(
    # ???
)

# Apache setup
# ------------

NEXTCLOUD_APACHE_SITE="nextCloud"
NEXTCLOUD_URL_ALIAS="cloud"
NEXTCLOUD_ROOT="${PHP_APPS}/nextCloud"

NEXTCLOUD_ALLOW="Allow from all"
#NEXTCLOUD_ALLOW="Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1"


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
                server)  remove_nextCloud_server ;;
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

    rstBlock "Die Installation von nextCloud erfolgt hinter einem
WEB-Server.  Die nextCloud selber richtet man dann online ein, was nicht mehr
Teil dieses Skriptes ist.

Bei dieser Installation wird die nextCloud hinter einem Apache WEB Server
installiert.  Sofern der erforderliche WEB-Server und Komponenten nicht bereits
installiert sind, werden diese nun installiert.  Die Installation des Apache
Servers nutzt die Methoden und Skripte, die in den handsOn bereitstehen, mehr
dazu kann man unter [1] nachlesen.

[1] https://return42.github.io/handsOn/apache_setup/index.html"

    if ! aptPackageInstalled apache2 ; then
	rstBlock "Apache ist noch nicht installiert. Für die nextCloud
Installation wird nun eine Apache Installation eingerichtet ..."
	waitKEY
	API_installApachePackages
	API_serverwide_cfg_install
	API_mod_security2_install
    fi

    if ! aptPackageInstalled libapache2-mod-php ; then
	rstBlock "nextCloud ist eine PHP Anwendung. Das PHP-Modul für Apache ist
noch nicht installiert. Die Basis-Installation für PHP wird nun vorgenommen ..."
	waitKEY
	installPHP
    fi

    rstBlock "Die Basis Installation des Apache ist bereits erfolgt. Es werden
nun alle weiteren, von nextCloud benötigten (APT) Pakete installiert."

    aptInstallPackages ${NEXTCLOUD_PACKAGES}
    waitKEY

    APACHE_install_site --eval ${NEXTCLOUD_APACHE_SITE}
    echo
    echo "Zur nextCloud Seite --> https://$(uname -n)/${NEXTCLOUD_URL_ALIAS}"
    waitKEY
    # FIXME: .... nun die nextCloud Installation
}


# ----------------------------------------------------------------------------
activate_server() {
    rstHeading "Aktivieren des nextCloud (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash | prefix_stdout
a2ensite nextCloud
systemctl force-reload apache2
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server() {
    rstHeading "De-Aktivieren des nextCloud (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash | prefix_stdout
a2dissite nextCloud
systemctl force-reload apache2
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

    rstHeading "Aufräumen Config & Setup Dateien" section
    ask_rm Ny "${APACHE_SITES_AVAILABE}/${NEXTCLOUD_APACHE_SITE}.conf"

    rstHeading "Aufräumen Nutzdaten" section
    ???

    rstBlock "Es wurden alle Komponenten entfernt, die eindeutig der nextCloud
zugeordnet werden konnten. Andere Komponenten wie z.B. die PHP Pakete und Apache
Module wurden nicht deinstalliert, da es sein kann, dass diese noch von anderen
Anwendungen auf diesem Host genutzt werden.

Falls Sie wissen, dass es sonst keine weiteren PHP oder Apache Anwendungen auf
diesem host gibt, können sie diese nun vollständig entfernen."

    if askNy "Soll der ganze Apache Server deinstalliert werden?" ; then
	API_apache_remove_all
    fi
    xxxxxxxxxxxxxxxxx
}


# ----------------------------------------------------------------------------
install_mariaDB(){
    rstHeading "Installation der mariaDB"
# ----------------------------------------------------------------------------

    rstBlock "Im Folgendem wird ein mariaDB Server eingerichtet.  mariaDB ist
der (echte) Open-Source Nachfolger von MySQL. Eine MySQL Abspaltung aus dem
Jahre 2009, die inzwischen bei weitem stabiler und performanter ist als MySQL,
welches in den Fuchteln von Oracle dem Marketing geschuldet kaputt gemacht
wurde.

- https://mariadb.com/

Bei der Installation des mariaDB Servers muss ein Root-Passwort für den
DB-Server vergeben werden. Dieses Passwort sollte man sich merken, da man es bei
weiteren Installationen noch benötigen wird!

- https://mariadb.com/kb/en/library/installing-mariadb-deb-files
"

    aptInstallPackages "${MARIADB_PACKAGES}"
    waitKEY
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
