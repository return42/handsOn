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

FIXME: aktuell in Arbeit



source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

SEAFILE_VERSION="6.3.4"
SEAFILE_PKG_URL="https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz"


SEAFILE_USER=seafile
SEAFILE_HOME=/home/${SEAFILE_USER}

DEB_PCKG="\
 python2.7 libpython2.7 python-setuptools python-ldap python-urllib3 \
 ffmpeg python-pip sqlite3 python-requests \
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
                server)  echo "not yet implemented"  ;;
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
        rstBlock "Apache ist noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
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

}

assert_user(){
    rstHeading "Benutzer $SEAFILE_USER" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
sudo adduser --shell /usr/sbin/nologin --disabled-password --home $SEAFILE_HOME --gecos 'Glances' $SEAFILE_USER
groups $SEAFILE_USER
EOF
    export GSEAFILE_HOME="$(sudo -i -u $SEAFILE_USER echo \$HOME)"
    rstBlock "export SEAFILE_HOME=$SEAFILE_HOME" | prefix_stdout
    waitKEY
}


install_seafile(){
    rstHeading "Install Seafile (user's HOME)" section

    local TAR="$(basename ${SEAFILE_PKG_URL})"
    cacheDownload "${SEAFILE_PKG_URL}" "${TAR}"

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

    TEE_stderr <<EOF | sudo -i -u $SEAFILE_USER | prefix_stdout
echo \$HOME
rm -rf \$HOME/seafile-server
cd \$HOME/seafile-server
tar -C \$HOME/seafile-server -xzf ${CACHE}/${TAR}
EOF

    sudo -i -u $SEAFILE_USER <<EOF
\$HOME/seafile-server/setup-seafile.sh
EOF

    # TEMPLATES_InstallOrMerge "${GLANCES_CONF}" root root 644
    waitKEY
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
