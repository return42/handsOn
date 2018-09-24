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

_PHP="php7.2"

NEXTCLOUD_PACKAGES="\
 libapache2-mod-php \
 ${_PHP}-gd ${_PHP}-json ${_PHP}-mysql \
 ${_PHP}-curl ${_PHP}-mbstring ${_PHP}-intl \
 ${_PHP}-imagick ${_PHP}-xml ${_PHP}-zip \
"
#NEXTCLOUD_DATA_FOLDER=/var/lib/???

# Apache setup
# ------------

NEXTCLOUD_APACHE_SITE="nextCloud"
NEXTCLOUD_URL_ALIAS="cloud"
NEXTCLOUD_ROOT="${PHP_APPS}/nextCloud"

NEXTCLOUD_ALLOW="Allow from all"
#NEXTCLOUD_ALLOW="Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1"

# maraiDB setup
# -------------

_mariaDB="10.1"
MARIADB_PACKAGES="\
    mariadb-server-${_mariaDB} \
"
MARIADB_DATA_FOLDER=/var/lib/mysql

# sudo mariadb -u root
# https://mariadb.com/kb/en/library/authentication-plugin-unix-socket/



CONFIG_BACKUP=(
    "${APACHE_SITES_AVAILABE}/${NEXTCLOUD_APACHE_SITE}.conf"
    # ??? "/etc/default/nextCloud"
)

CONFIG_BACKUP_ENCRYPTED=(
    # ???
)

DATA_BACKUP=(
    # "$NEXTCLOUD_DATA_FOLDER"
    # "$MARIADB_DATA_FOLDER"
)


# ----------------------------------------------------------------------------
info(){
# ----------------------------------------------------------------------------

    rstBlock "Die Installation von nextCloud erfolgt hinter einem WEB-Server.
Die nextCloud Anwendung selbst wird danach online eingerichtet.

Bei der hier vorgeschlagenen Installation wird die nextCloud hinter einem Apache
WEB Server installiert.  Sofern der erforderliche WEB-Server und die Komponenten
nicht bereits installiert sind, werden diese installiert.  Die Installation des
Apache Servers nutzt die Methoden und Skripte, die in den handsOn bereitstehen,
mehr dazu kann man unter [1] nachlesen.

Neben dem WEB-Server benötigt nextCloud noch eine Datenbank. Es wird der von
nextCloud empfohlene DB-Server mariaDB [2] installiert [3]. mariaDB ist der
(echte) Open-Source Nachfolger von MySQL. Eine MySQL Abspaltung aus dem Jahre
2009, die inzwischen stabiler und performanter ist als MySQL, welches in den
Fuchteln von Oracle dem Marketing geschuldet kaputt gefrickelt wird.

Entgegen den z.T. noch veralteten Dokumentationen wird bei der DB Installation
kein Passwort mehr vergeben. Die Standard Installation bei debian/Ubuntu
verwendet zur Authentifizierung das Plugin 'Unix Socket' [4]. Die root-Anmeldung
an der DB erfolgt als root Benutzer des localhost ohne weitere Passwort-Abfrage.
So kann man sich dann mittels sudo an der DB als root (User der DB) anmelden, ohne
dass man dafür ein Passwort eingeben muss::

  sudo mariadb
"
    echo "\
[1] https://return42.github.io/handsOn/apache_setup/index.html
[2] https://mariadb.com
[3] https://mariadb.com/kb/en/library/installing-mariadb-deb-files
[4] https://mariadb.com/kb/en/library/authentication-plugin-unix-socket/
"
}


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:
  $(basename $0) info
  $(basename $0) install    [server|mariaDB]
  $(basename $0) remove     [server|mariaDB]
  $(basename $0) activate   [server|mariaDB]
  $(basename $0) deactivate [server|mariaDB]

EOF
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "nextCloud" part
# ----------------------------------------------------------------------------

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
	info) info;;

	install)
            sudoOrExit
            case $2 in
                server)  install_nextCloud_server ;;
                mariaDB)  install_mariaDB ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                server)  remove_nextCloud_server ;;
		mariaDB) remove_mariaDB ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  activate_server ;;
		mariaDB) activate_mariaDB ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server ;;
		mariaDB) deactivate_mariaDB ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}


# ----------------------------------------------------------------------------
install_nextCloud_server(){
    rstHeading "Installation nextCloud"
# ----------------------------------------------------------------------------


    install_mariaDB

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

    rstBlock "Es wurden alle Komponenten entfernt, die eindeutig der nextCloud
zugeordnet werden konnten. Andere Komponenten wie z.B. die PHP Pakete, mariaDB
und Apache Module wurden nicht deinstalliert, da es sein kann, dass diese noch
von anderen Anwendungen auf diesem Host genutzt werden.  Falls es keine weiteren
Apache (WEB), PHP oder mariaDB Anwendungen gibt, können diese vollständig
entfernt werden ..."

    waitKEY
    API_apache_remove_all

    rstHeading "PHP"
    if askNy "Soll PHP deinstalliert werden?" ; then
	aptPurgePackages ${NEXTCLOUD_PACKAGES}
	rstBlock "Deinstallation PHP abgeschlossen"
    fi

    remove_mariaDB

    rstHeading "Aufräumen Nutzdaten" section
    ??? Welche Nutzdaten müssen ggf. noch abgeräumt werden ???
}


# ----------------------------------------------------------------------------
install_mariaDB(){
    rstHeading "Installation der mariaDB"
# ----------------------------------------------------------------------------

    rstBlock "Im Folgendem wird ein mariaDB Server eingerichtet."

    aptInstallPackages ${MARIADB_PACKAGES}
    systemctl status mariadb.service
    waitKEY
}

# ----------------------------------------------------------------------------
remove_mariaDB(){
    rstHeading "De-Installation der mariaDB"
# ----------------------------------------------------------------------------

    if askNy "Soll der mariaDB (aka mySQL) deinstalliert werden?" ; then
	deactivate_mariaDB
	aptPurgePackages ${MARIADB_PACKAGES}
	rstBlock "Deinstallation mariaDB abgeschlossen"
    fi
}

# ----------------------------------------------------------------------------
activate_mariaDB(){
    rstHeading "Aktivierung mariaDB Dienst" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl enable mariadb.service
systemctl restart mariadb.service
EOF
    waitKEY 10
}


# ----------------------------------------------------------------------------
deactivate_mariaDB(){
    rstHeading "De-Aktivierung mariaDB Dienst" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl stop mariadb.service
systemctl disable mariadb.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
