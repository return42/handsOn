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

NEXTCLOUD_DOWNLOAD_URL=https://download.nextcloud.com/server/releases/
# leave this empty to get *latest*
#NEXTCLOUD_VERSION=14.0.1

#NEXTCLOUD_DATA_FOLDER=/var/lib/???

# WEB setup
# ------------

NEXTCLOUD_APACHE_SITE="nextCloud"
NEXTCLOUD_URL_ALIAS="cloud"
NEXTCLOUD_ROOT="${PHP_APPS}/nextcloud"

NEXTCLOUD_ALLOW="Allow from all"
#NEXTCLOUD_ALLOW="Allow from fd00::/8 192.168.0.0/16 fe80::/10 127.0.0.0/8 ::1"

# DB-Setup
# --------

NEXTCLOUD_DB_NAME=nextcloud
NEXTCLOUD_DB_USER=nextcloud
NEXTCLOUD_DB_HOST=localhost


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

    rstBlock "Die Installation von nextCloud erfolgt hinter einem WEB-Server
(https://$(uname -n)/${NEXTCLOUD_URL_ALIAS}).  Die nextCloud Anwendung selbst
wird danach online eingerichtet."

    rstHeading "WEB-Server Apache" section

    rstBlock "Bei der hier vorgeschlagenen Installation wird die nextCloud
hinter einem Apache WEB Server installiert.  Sofern der erforderliche WEB-Server
und die Komponenten nicht bereits installiert sind, werden diese installiert.
Die Installation des Apache Servers nutzt die Methoden und Skripte, die in den
handsOn bereitstehen, mehr dazu kann man unter [1] nachlesen."

    rstHeading "DB-Server mariaDB" section

    rstBlock "Neben dem WEB-Server benötigt nextCloud noch eine Datenbank.  Es
wird der von nextCloud empfohlene DB-Server mariaDB [2] installiert [3]. mariaDB
ist der (echte) Open-Source Nachfolger von MySQL. Eine MySQL Abspaltung aus dem
Jahre 2009, die inzwischen stabiler und performanter ist als MySQL, welches in
den Fuchteln von Oracle dem Marketing geschuldet kaputt gefrickelt wird.

Entgegen den z.T. noch veralteten (Stand 09/2018) Dokumentationen [5] wird bei
der DB Installation kein Passwort mehr vergeben. Die Standard Installation bei
debian/Ubuntu verwendet zur Authentifizierung das Plugin 'Unix Socket' [4]. Die
root-Anmeldung an der DB erfolgt als root Benutzer des localhost ohne weitere
Passwort-Abfrage.  So kann man sich dann mittels sudo an der DB als root (User
der DB) anmelden, ohne dass man dafür ein Passwort eingeben muss::

  sudo mariadb
"

    rstHeading "DB-Server mariaDB" section

    rstBlock "Die exemplarische Installation für Ubuntu 16.04 LTS, die man bei
nextCloud findet [5] ist leider nicht so gut.  Eine gute Anleitung zur
Installation gibt es bei ArchLinux [6], man muss dabei nur wissen, dass die
Pfade & Pakete auf Debian anders sind als auf ArchLinux."

    echo "
[1] https://return42.github.io/handsOn/apache_setup/index.html
[2] https://mariadb.com
[3] https://mariadb.com/kb/en/library/installing-mariadb-deb-files
[4] https://mariadb.com/kb/en/library/authentication-plugin-unix-socket/
[5] https://docs.nextcloud.com/server/14/admin_manual/installation/source_installation.html
[6] https://wiki.archlinux.org/index.php/Nextcloud
[7] https://github.com/nextcloud
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
    rstHeading "Installation nextCloud" part
# ----------------------------------------------------------------------------

    info
    waitKEY

    rstHeading "Installation der Voraussetzungen"

    if ! aptPackageInstalled apache2 ; then
	rstBlock "Apache ist noch nicht installiert. Für die nextCloud
Installation wird nun eine Apache Installation eingerichtet ..."
	waitKEY
	API_installApachePackages
	API_serverwide_cfg_install
	API_mod_security2_install
	# FIXME: aktuell reicht ein "SecRuleEngine Off" scheinbar nicht aus.
	mod_security2_deactivate
    fi

    info_msg "Voraussetzung: ${BGreen}Apache --> OK${_color_Off}"

    if ! aptPackageInstalled libapache2-mod-php ; then
	rstBlock "nextCloud ist eine PHP Anwendung. Das PHP-Modul für Apache ist
noch nicht installiert. Die Basis-Installation für PHP wird nun vorgenommen ..."
	waitKEY
	installPHP
    fi

    info_msg "Voraussetzung: ${BGreen}PHP --> OK${_color_Off}"

    rstBlock "Die Basis Installation des Apache ist bereits erfolgt. Es werden
nun alle weiteren, von nextCloud benötigten (APT) Pakete installiert."

    aptInstallPackages ${NEXTCLOUD_PACKAGES}
    info_msg "Voraussetzung: ${BGreen}APTPaket Installationen --> OK${_color_Off}"

    install_mariaDB
    setup_nextCloud_DB
    info_msg "Voraussetzung: ${BGreen}mariaDB --> OK${_color_Off}"

    download_install_nextcloud

    rstHeading "Einrichten der Apache-Site für nextCloud"
    APACHE_install_site --eval ${NEXTCLOUD_APACHE_SITE}
    echo
    echo "Zur nextCloud Seite --> https://$(uname -n)/${NEXTCLOUD_URL_ALIAS}"
    waitKEY
}

# ----------------------------------------------------------------------------
download_install_nextcloud(){
    rstHeading "download & install nextCloud $(nextcloud_version)"
# ----------------------------------------------------------------------------
    echo
    NEXTCLOUD_TAR="nextcloud-$(nextcloud_version).tar.bz2"

    cacheDownload "${NEXTCLOUD_DOWNLOAD_URL}/${NEXTCLOUD_TAR}" "${NEXTCLOUD_TAR}" askYn

    rm -rf "${CACHE}/nextCloud"
    mkdir -p "${CACHE}/nextCloud"
    tar -C "${CACHE}/nextCloud" -xjf "${CACHE}/${NEXTCLOUD_TAR}" | prefix_stdout
    if [[ -d "${NEXTCLOUD_ROOT}" ]]; then
	echo "Alte Installation wird verschoben: ${NEXTCLOUD_ROOT}_$(timestamp)"
	mv "${NEXTCLOUD_ROOT}"  "${NEXTCLOUD_ROOT}_$(timestamp)"
    fi
    waitKEY
    installFolder "${CACHE}/nextCloud/nextcloud" "${NEXTCLOUD_ROOT}/.." root ${WWW_USER}

    rstHeading "Anlegen benötigter Ordner" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
    mkdir -p "${NEXTCLOUD_ROOT}/data"
    mkdir -p "${NEXTCLOUD_ROOT}/assets"
EOF
    waitKEY

    rstHeading "Berechtigungen setzen" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
find ${NEXTCLOUD_ROOT}/ -type f -print0 | xargs -0 chmod 0640
find ${NEXTCLOUD_ROOT}/ -type d -print0 | xargs -0 chmod 0750

chown -R root:${WWW_USER} ${NEXTCLOUD_ROOT}/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/apps/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/assets/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/config/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/data/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/themes/
chown -R ${WWW_USER}:${WWW_USER} ${NEXTCLOUD_ROOT}/updater/

chmod +x ${NEXTCLOUD_ROOT}/occ

[ -f ${NEXTCLOUD_ROOT}/.htaccess ] && chmod 0644 ${NEXTCLOUD_ROOT}/.htaccess
[ -f ${NEXTCLOUD_ROOT}/.htaccess ] && chown root:${WWW_USER} ${NEXTCLOUD_ROOT}/.htaccess
[ -f ${NEXTCLOUD_ROOT}/data/.htaccess ] && chmod 0644 ${NEXTCLOUD_ROOT}/data/.htaccess
[ -f ${NEXTCLOUD_ROOT}/data/.htaccess ] && chown root:${WWW_USER} ${NEXTCLOUD_ROOT}/data/.htaccess
EOF
    waitKEY

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
    rstHeading "De-Installation nextCloud" part
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



sql_SELECT_EXISTS_FROM(){
    local retVal=$(sudo mariadb -sse "SELECT EXISTS( SELECT 1 FROM ${1})" )
    [[ $retVal == "1" ]]
}


# ----------------------------------------------------------------------------
install_mariaDB(){
    rstHeading "Installation der mariaDB"
# ----------------------------------------------------------------------------

    aptInstallPackages ${MARIADB_PACKAGES}
    rstHeading "Status des DB-Servers" section
    echo
    systemctl status mariadb.service
}


# ----------------------------------------------------------------------------
setup_nextCloud_DB(){
    rstHeading "Setup Datenbank für nextCloud" section
# ----------------------------------------------------------------------------

    rstBlock "Für nextCloud werden der DB-Benutzer
(${NEXTCLOUD_DB_USER}@${NEXTCLOUD_DB_HOST}), eine Datenbank
(${NEXTCLOUD_DB_NAME}) und die erforderlichen Zugriffsrechten eingerichtet."

    if sql_SELECT_EXISTS_FROM "mysql.user WHERE user='${NEXTCLOUD_DB_USER}'"
    then
	info_msg "DB-Benutzer ${NEXTCLOUD_DB_USER} existiert bereits."
    else
	info_msg "DB-Benutzer ${NEXTCLOUD_DB_USER} existiert noch nicht / muss angelegt werden."
	rstBlock "Für den Benutzer muss ein Passwort vergeben werden.
Es wird später noch benötigt / ${BRed}merken!${_color_Off}"
	askPassphrase "  password"
	NEXTCLOUD_DB_PWD="$passphrase"
	TEE_stderr <<EOF | sudo mariadb --table | prefix_stdout
CREATE USER '${NEXTCLOUD_DB_USER}'@'${NEXTCLOUD_DB_HOST}' IDENTIFIED BY '${NEXTCLOUD_DB_PWD}';
quit
EOF
    fi
    waitKEY

    if sql_SELECT_EXISTS_FROM "information_schema.schemata WHERE schema_name = '${NEXTCLOUD_DB_NAME}'"
    then
	info_msg "Datenbank ${NEXTCLOUD_DB_NAME} existiert bereits."
    else
	info_msg "Datenbank ${NEXTCLOUD_DB_NAME} existiert noch nicht / muss angelegt werden."
	# https://docs.nextcloud.com/server/14/admin_manual/configuration_database/linux_database_configuration.html#configuring-a-mysql-or-mariadb-database
	#
	# Die Doku ist z.T. nicht ganz aktuell: man sollte bei neuen Datenbanken
	# immer 'CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci' wählen!
	TEE_stderr <<EOF | sudo mariadb --table | prefix_stdout
CREATE DATABASE IF NOT EXISTS ${NEXTCLOUD_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
quit
EOF
    fi
    waitKEY

    info_msg "Zugriffsrechte DB-Benutzers (${NEXTCLOUD_DB_USER}) auf DB (${NEXTCLOUD_DB_NAME}) "
    TEE_stderr <<EOF | sudo mariadb --table | prefix_stdout
GRANT ALL PRIVILEGES ON ${NEXTCLOUD_DB_NAME}.* TO '${NEXTCLOUD_DB_USER}'@'${NEXTCLOUD_DB_HOST}';
quit
EOF
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

nextcloud_version(){
    if [[ -z $NEXTCLOUD_VERSION ]]; then
	NEXTCLOUD_VERSION=$(curl "$NEXTCLOUD_DOWNLOAD_URL" 2>/dev/null \
				| sed -n 's/.*href="nextcloud-\([0-9]*.[0-9]*.[0-9]*\).*/\1/p' \
				| sort -V \
				| tail -1 )
    fi
    echo $NEXTCLOUD_VERSION
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
