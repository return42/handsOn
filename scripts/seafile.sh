#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     seafile.sh
# -- Copyright (C) 2019 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     install Seafile file sharing server
# ----------------------------------------------------------------------------

# https://www.seafile.com/en/download/
# https://manual.seafile.com/deploy/using_sqlite.html

# FIXME: aktuell in Arbeit Logrotate ..

# https://manual.seafile.com/deploy/using_logrotate.html


# FIXME: es muss envsubst verwendet werden
# (set -o posix ; set) \
#     | grep "^[A-Z][A-Z=-9_]*=" \
#     | grep -v ^BASH \
#     | (while IFS= read line; do echo -e "export $line$";  done) \
#           > test123.tmpl.env


# Artikel im Netz:
#
# https://manual.seafile.com/config/
# https://www.pug.org/mediawiki/index.php/Seafile-als-Unterordner
# https://manual.seafile.com/extension/webdav.html
# https://blog.yumdap.net/dropbox-alternative-seafile-mit-tls-unter-apache-einrichten/





source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

SEAFILE_SERVER_NAME=${APACHE_SERVER_NAME:-$(hostname)}
ORGANIZATION=${ORGANIZATION-myOrg}

SEAFILE_SYSTEMD_UNITS="\
  /etc/systemd/system/seafile.service  \
  /etc/systemd/system/seahub.service  \
"

# HINT: die conf/ccnet.conf muss erst über das setup-seafile.sh erzeugt werden,
#       das legt nämlich den P-Key (RSA) und berechnet dazu die "ID" (sha1) zu
#       dem RSA P-Key (siehe SEAFILE_ID).

SEAFILE_CONFIGS="\
  /home/seafile/conf/ccnet.conf \
  /home/seafile/conf/gunicorn.conf \
  /home/seafile/conf/seafdav.conf \
  /home/seafile/conf/seafile.conf \
  /home/seafile/conf/seahub_settings.py \
"

SEAFILE_VERSION="6.3.4"
SEAFILE_PKG_URL="https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz"

SEAFILE_USER=seafile
SEAFILE_HOME=/home/${SEAFILE_USER}

SEAFILE_BIND=127.0.0.1
SEAFILE_PORT=48736  # default 8082

SEAHUB_PORT=48737   # default 8000

SEAFILE_CONF_DIR=${SEAFILE_USER}/conf

SEAFILE_SEND_MAILS="False"  # "True"
SEAFILE_TIME_ZONE="CET"  # "UTC"

# Apache Redirect
SEAFILE_APACHE_URL="/seafile"   # Apache ridirect for all the seafile components (SITE_ROOT)
SEAFILE_APACHE_SITE=seafile

# FIXME: ich habe WebDAV erst mal deaktiviert (default)
SEAFILE_WEBDAV_URL="/seafile-dav"
SEAFILE_WEBDAV_PORT=${SEAFILE_WEBDAV_PORT:-48762}

SEAHUB_SECRET_KEY="$(cat /dev/urandom | tr -cd 'a-z0-9!@#$%^&*(\-_=+)' | fold -w 50 | head -n 1)"

DEB_PCKG="\
 python2.7 libpython2.7 python-setuptools python-ldap python-urllib3 \
 ffmpeg python-pip sqlite3 python-requests \
 virtualenv \
"

# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    # FIXME:
    # $(basename $0) info

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) install    [server]
  $(basename $0) remove     [server]
  $(basename $0) activate   [server]
  $(basename $0) deactivate [server]

EOF
}


# ----------------------------------------------------------------------------
main(){
    rstHeading "Seafile Service" part
# ----------------------------------------------------------------------------

    _usage="${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
        # info) less "${REPO_ROOT}/docs/seafile.rst" ;;

        install)
            sudoOrExit
            case $2 in
                server)  setup_server ;;
                *)       usage "$_usage"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                server)  remove_server ;;
                *)       usage "$_usage"; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  activate_server  ;;
                *)       usage "$_usage"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server  ;;
                *)       usage "$_usage"; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}

# ----------------------------------------------------------------------------
setup_server(){
    rstHeading "Installation Seafile"
# ----------------------------------------------------------------------------

    rstBlock "Es wird Seafile mit einer SQLite Datenbank eingerichtet"

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache ist noch nicht installiert, die Installation sollte wie
folgt durchgeführt werden::

  ${SCRIPT_FOLDER}/apache_setup.sh install server"
        return 42
    fi

    if ! askYn "Soll Seafile installiert werden?"; then
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    sudo -H -u $SEAFILE_USER bash ${SEAFILE_HOME}/seafile-server-latest/seahub.sh stop
    sudo -H -u $SEAFILE_USER bash ${SEAFILE_HOME}/seafile-server-latest/seafile.sh stop
    deactivate_server

    rstHeading "Benötigte System Pakete" section
    rstPkgList ${DEB_PCKG}
    echo
    apt-get install -y ${DEB_PCKG}
    waitKEY

    assert_user
    install_seafile_server
}

# ----------------------------------------------------------------------------
assert_user(){
    rstHeading "Benutzer $SEAFILE_USER" section
# ----------------------------------------------------------------------------

    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
sudo adduser --shell /usr/sbin/nologin --disabled-password --home $SEAFILE_HOME --gecos 'Glances' $SEAFILE_USER
groups $SEAFILE_USER
EOF
    export GSEAFILE_HOME="$(sudo -i -u $SEAFILE_USER echo \$HOME)"
    rstBlock "export SEAFILE_HOME=$SEAFILE_HOME" | prefix_stdout
    waitKEY
}

# ----------------------------------------------------------------------------
install_seafile_server(){
# ----------------------------------------------------------------------------

    rstHeading "Install Seafile (into user's HOME)" section

    local TAR="$(basename ${SEAFILE_PKG_URL})"

    rstBlock "richte Python Umgebung ein ..."

    TEE_stderr <<EOF | bash | prefix_stdout
cd ${SEAFILE_HOME}
virtualenv --python=python2 pyenv
source ${SEAFILE_HOME}/pyenv/bin/activate
pip install Pillow==4.3.0
pip install moviepy
EOF
    waitKEY

    rstBlock "installiere seafile-server Software"

    cacheDownload "${SEAFILE_PKG_URL}" "${TAR}"

    TEE_stderr <<EOF | sudo -H -u $SEAFILE_USER bash | prefix_stdout
rm -rf ${SEAFILE_HOME}/seafile-server-*
tar -C ${SEAFILE_HOME} -xzf ${CACHE}/${TAR}
EOF

    # FIXME
    pushd "${SEAFILE_HOME}/seafile-server-${SEAFILE_VERSION}" > /dev/null
    TEE_stderr <<EOF |  sudo -H -u $SEAFILE_USER bash | prefix_stdout
source ${SEAFILE_HOME}/pyenv/bin/activate
./setup-seafile.sh auto \
    -n "${SEAFILE_SERVER_NAME}" \
    -i "${SEAFILE_BIND}" \
    -p "${SEAFILE_PORT}" \
    -d "${SEAFILE_HOME}/seafile-data"
EOF
    popd > /dev/null
    waitKEY

    rstHeading "Seafile config ..." section

    SEAFILE_ID=$(sed -n 's/\s*ID\s*=\s*\([0-9a-z]*\)\s*$/\1/p' /home/seafile/conf/ccnet.conf)
    rstBlock "ccnet ID = $SEAFILE_ID"
    for ITEM in ${SEAFILE_CONFIGS[@]}; do
        echo
        TEMPLATES_InstallOrMerge --eval "$ITEM"  root root 644
    done
    waitKEY

    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seafile.sh start'
    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seahub.sh start'

    rstBlock "Dienst wurde lokal eingerichtet ..."
    rstBlock "  --> http://${SEAFILE_BIND}:${SEAHUB_PORT}"
    waitKEY

    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seahub.sh stop'
    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seafile.sh stop'
    waitKEY

    rstHeading "Install System-D Units ..." section

    for ITEM in ${SEAFILE_SYSTEMD_UNITS[@]}; do
        echo
        TEMPLATES_InstallOrMerge --eval "$ITEM"  root root 644
    done
    waitKEY

    rstHeading "Apache Site mit ProxyPass einrichten" section
    echo
    a2enmod proxy_http
    a2enmod rewrite
    APACHE_install_site --eval ${SEAFILE_APACHE_SITE}

    activate_server

    rstBlock "Dienst ist eingerichtet ..."
    rstBlock "  --> https://${APACHE_SERVER_NAME}${SEAFILE_APACHE_URL}"
    waitKEY
}


# ----------------------------------------------------------------------------
activate_server(){
    rstHeading "Aktivieren der Seafile Dienste" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2ensite ${SEAFILE_APACHE_SITE}
systemctl force-reload apache2
EOF

    for ITEM in ${SEAFILE_SYSTEMD_UNITS[@]}  ; do
	rstBlock "enable $(basename "$ITEM") ..."
	echo
	systemctl enable  $(basename "$ITEM") 2>&1  | prefix_stdout
	systemctl restart $(basename "$ITEM") 2>&1  | prefix_stdout
	systemctl status  $(basename "$ITEM") 2>&1  | prefix_stdout
    done
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server(){
    rstHeading "De-Aktivieren der Seafile Dienste" section
# ----------------------------------------------------------------------------
    echo ""
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl ${SEAFILE_APACHE_SITE}
systemctl force-reload apache2
EOF

    for ITEM in ${SEAFILE_SYSTEMD_UNITS[@]}  ; do
	rstBlock "disable $(basename "$ITEM") ..."
	echo
	systemctl stop    $(basename "$ITEM") 2>&1  | prefix_stdout
	systemctl disable $(basename "$ITEM") 2>&1  | prefix_stdout
	systemctl status  $(basename "$ITEM") 2>&1  | prefix_stdout
    done
    waitKEY 10
}

# ----------------------------------------------------------------------------
remove_server() {
    rstHeading "De-Installation Seafile"
# ----------------------------------------------------------------------------

    if ! askYn "Soll Seafile deinstalliert werden?"; then
        return
    fi
    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seahub.sh stop'
    sudo -H -u $SEAFILE_USER /bin/bash -c 'source ~/pyenv/bin/activate && ~/seafile-server-latest/seafile.sh stop'

    deactivate_server

    for ITEM in ${SEAFILE_SYSTEMD_UNITS[@]}; do
	rstBlock "delete $ITEM ..."
	rm -f "${ITEM}"
    done

    rstBlock "delete apache site: ${SEAFILE_APACHE_SITE}.conf ..."
    rm -f "${APACHE_SITES_AVAILABE}/${SEAFILE_APACHE_SITE}.conf"
    systemctl force-reload apache2

    rstHeading "Benutzer $SEAFILE_USER" section
    echo
    # FIXME: ... hier muss noch eine Anfrage rein, ob der HOME Ordner wwirklich
    # gelöscht werden soll  ... vorher aber DATENSICHERUNG!!!!!
    userdel -r -f "$SEAFILE_USER"
}




# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
