#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     searx.sh
# -- Copyright (C) 2019 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     searx Installation mit Apache Konfiguration
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

SEARX_APT_PACKAGES="\
libapache2-mod-uwsgi uwsgi uwsgi-plugin-python3 \
  git build-essential libxslt-dev python3-dev python3-babel zlib1g-dev \
  libffi-dev libssl-dev"

# SEARX_DESCRIPTION="Searx (self hosted)"
SEARX_USER=searx
SEARX_HOME="/home/$SEARX_USER"
SEARX_VENV="${SEARX_HOME}/searx-venv"

SEARX_REPO_FOLDER="${SEARX_HOME}/searx-src"
SEARX_SETTINGS="${SEARX_REPO_FOLDER}/searx/settings.yml"

# Apache Redirect URL
SEARX_APACHE_DOMAIN="$(uname -n)"
SEARX_APACHE_URL="/searx"
SEARX_APACHE_SITE=searx

SEARX_GIT_URL="https://github.com/asciimoo/searx.git"

# SEARX_LOG_FOLDER="/var/log/$SEARX_APACHE_URL"

CONFIG_BACKUP=(
    "${APACHE_SITES_AVAILABE}/${SEARX_APACHE_SITE}.conf"
)

CONFIG_BACKUP_ENCRYPTED=(
    "${SEARX_SETTINGS}"
)


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
        info) less "${REPO_ROOT}/docs/searx.rst" ;;

        install)
            sudoOrExit
            case $2 in
                server)  install_server ;;
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
                server)  activate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}

# ----------------------------------------------------------------------------
install_server(){
     rstHeading "Installation Searx"
# ----------------------------------------------------------------------------

    if ! askYn "Soll eine Searx Instanz installiert werden?"; then
        return 42
    fi

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache is noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    deactivate_server

    TITLE='Installation erforderlicher Pakete' \
	 aptInstallPackages $SEARX_APT_PACKAGES

    assert_user
    clone_repo
    create_venv
    configure_searx
    test_local_searx

    err_msg "TODO ..."
}

# ----------------------------------------------------------------------------
remove_server() {
    rstHeading "De-Installation Searx"
# ----------------------------------------------------------------------------

    if ! askYn "Soll die Searx Instanz deinstalliert werden?"; then
        return
    fi
    deactivate_server

    rstHeading "Benutzer $SEARX_USER" section
    if askNy "Soll der Benutzer wirklich ganz gelöscht werden? Alle Daten gehen verloren!!!"; then
        userdel -r -f "$SEARX_USER"
    else
        rstBlock "Benutzerdaten [$(du -sh $SEARX_HOME)] bleiben erhalten."
    fi
}

# ----------------------------------------------------------------------------
assert_user(){
    rstHeading "Benutzer $SEARX_USER" section
# ----------------------------------------------------------------------------
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
useradd $SEARX_USER -d $SEARX_HOME
groups $SEARX_USER
EOF

    rstBlock "Benutzer $SEARX_USER wurde angelegt"
    TEE_stderr 1 <<EOF | su ${SEARX_USER} | prefix_stdout
ls -la \$HOME
EOF
    waitKEY

}

# ----------------------------------------------------------------------------
clone_repo(){
    rstHeading "Download/Clone der Searx Sourcen" section
# ----------------------------------------------------------------------------

    rstBlock "Repository in ${SEARX_REPO_FOLDER}"
    echo
    CACHE="${SEARX_HOME}" SUDO_USER=$SEARX_USER\
	 cloneGitRepository "${SEARX_GIT_URL}"  "$(basename ${SEARX_REPO_FOLDER})"
    info_msg "create backup: $SEARX_SETTINGS.origin.backup"
    pushd "${SEARX_REPO_FOLDER}" > /dev/null
    git show "HEAD:searx/settings.yml" > "$SEARX_SETTINGS.origin.backup"
    popd > /dev/null
    waitKEY
}

# ----------------------------------------------------------------------------
create_venv(){
    rstHeading "Bereitstellen der virtuellen Umgebung (python)" section
# ----------------------------------------------------------------------------

    rstBlock "Virtuelle Python Umgebung in ${SEARX_VENV}"
    echo
    TEE_stderr 1 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
rm -rf ${SEARX_VENV}
python3 -m venv ${SEARX_VENV}
. ${SEARX_VENV}/bin/activate
${SEARX_REPO_FOLDER}/manage.sh update_packages
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
configure_searx(){
    rstHeading "Konfiguration Searx" section
# ----------------------------------------------------------------------------

    rstBlock "Virtuelle Python Umgebung in ${SEARX_VENV}"
    echo

    # TEMPLATES_InstallOrMerge --eval $SEARX_SETTINGS searx searx 6

    TEE_stderr 1 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" $SEARX_SETTINGS
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
test_local_searx(){
# ----------------------------------------------------------------------------

    rstHeading "Test der Searx Installation" section
    echo
    TEE_stderr <<EOF | sudo -i -u $SEARX_USER | prefix_stdout
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
sed -i -e "s/debug : False/debug : True/g" $SEARX_SETTINGS
timeout 20 python3 searx/webapp.py &
sleep 5
curl --location --verbose --head --insecure http://127.0.0.1:8888/  2>&1
sed -i -e "s/debug : True/debug : False/g" $SEARX_SETTINGS
EOF
    waitKEY
}

#     rstHeading "Apache Site mit ProxyPass einrichten" section
#     echo
#     a2enmod proxy_http
#     APACHE_install_site --eval ${GOGS_APACHE_SITE}
#     rstBlock "Dienst: https://${GOGS_APACHE_DOMAIN}${GOGS_APACHE_URL}"
#     waitKEY

#     rstHeading "Test des Gogs Dienstes im WWW" section
#     echo
#     TEE_stderr <<EOF | bash | prefix_stdout
# curl --location --verbose --head --insecure https://${GOGS_APACHE_DOMAIN}${GOGS_APACHE_URL}
# EOF
#     waitKEY


# ----------------------------------------------------------------------------
activate_server(){
    rstHeading "Aktivieren des Searx (service)" section
# ----------------------------------------------------------------------------
    echo ""
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2ensite gogs
systemctl force-reload apache2
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server(){
    rstHeading "De-Aktivieren des Searx (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2dissite searx
systemctl force-reload apache2
EOF
    waitKEY 10
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
