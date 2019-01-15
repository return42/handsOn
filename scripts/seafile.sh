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

APACHE_SERVER_NAME=${APACHE_SERVER_NAME:-$(hostname)}
ORGANIZATION=${ORGANIZATION-myOrg}

SEAFILE_VERSION="6.3.4"
SEAFILE_PKG_URL="https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz"

SEAFILE_USER=seafile
SEAFILE_HOME=/home/${SEAFILE_USER}
#SEAFILE_PORT=xxxxx
SEAFILE_BIND=127.0.0.1
SEAFILE_PORT=48736
SEAFILE_CONF_DIR=${SEAFILE_USER}/conf

SEAFILE_SEND_MAILS="False"  # "True"
SEAFILE_TIME_ZONE="CET"  # "UTC"

# Apache Redirect
SEAFILE_APACHE_URL="/seafile/"
SEAFILE_APACHE_SITE=seafile
SEAFILE_ID="$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 40 | head -n 1)"
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

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) info
  $(basename $0) install    [server]
  $(basename $0) remove     [server]
  $(basename $0) activate   [server]
  $(basename $0) deactivate [server]

EOF
}


# ----------------------------------------------------------------------------
main(){
    rstHeading "Gogs / Go Git Service" part
# ----------------------------------------------------------------------------

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
        info) less "${REPO_ROOT}/docs/gogs.rst" ;;

        install)
            sudoOrExit
            case $2 in
                server)  setup_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                server)  remove_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  echo "not yet implemented"  ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  echo "not yet implemented"  ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
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
    rstHeading "Install Seafile (into user's HOME)" section
# ----------------------------------------------------------------------------

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
mkdir -p ${SEAFILE_HOME}/seafile-server
cd ${SEAFILE_HOME}/seafile-server
tar -C ${SEAFILE_HOME} -xzf ${CACHE}/${TAR}
EOF

    pushd "${SEAFILE_HOME}/seafile-server-${SEAFILE_VERSION}" 2> /dev/null
    sudo -H -u $SEAFILE_USER bash -i ./setup-seafile.sh auto -n localhost -i 127.0.0.1 -p 
    popd 2> /dev/null
    # TEMPLATES_InstallOrMerge "${GLANCES_CONF}" root root 644
    waitKEY
}



# ----------------------------------------------------------------------------
remove_server() {
    rstHeading "De-Installation Seafile"
# ----------------------------------------------------------------------------

    if ! askYn "Soll Seafile deinstalliert werden?"; then
        return
    fi

    # FIXME ....
  
    # deactivate_server
    # rm -f "${SEAFILE_SYSTEMD_UNIT}"
    # rm -f "${APACHE_SITES_AVAILABE}/${SEAFILE_APACHE_SITE}.conf"
    # systemctl force-reload apache2

    rstHeading "Benutzer $SEAFILE_USER" section
    echo
    userdel -r -f "$SEAFILE_USER"
}




# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
