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

SEARX_GIT_URL="https://github.com/return42/searx.git"
SEARX_GIT_BRANCH="dm-cloud"

SEARX_APT_PACKAGES="\
libapache2-mod-uwsgi uwsgi uwsgi-plugin-python3 \
  git build-essential libxslt-dev python3-dev python3-babel zlib1g-dev \
  libffi-dev libssl-dev"

SEARX_USER=searx
SEARX_HOME="/home/$SEARX_USER"
SEARX_VENV="${SEARX_HOME}/searx-venv"
SEARX_REPO_FOLDER="${SEARX_HOME}/searx-src"
SEARX_SETTINGS="${SEARX_REPO_FOLDER}/searx/settings.yml"
SEARX_INSTANCE_NAME="${SEARX_INSTANCE_NAME:-searX@$(uname -n)}"

# Apache Settings
SEARX_APACHE_DOMAIN="$(uname -n)"
SEARX_APACHE_URL="/searx"
SEARX_APACHE_SITE=searx

# uWSGI Settings
SEARX_UWSGI_APP=searx.ini

CONFIG_BACKUP=(
    "${APACHE_SITES_AVAILABE}/${SEARX_APACHE_SITE}.conf"
    "${uWSGI_SETUP}/apps-available/${SEARX_UWSGI_APP}"
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
  $(basename $0) udpate     [server]
  $(basename $0) remove     [server]
  $(basename $0) activate   [server]
  $(basename $0) deactivate [server]
  $(basename $0) shell
  $(basename $0) config     [server|diff]

:install:     Install searX instance
:update:      Update searX instance
:remove:      drop searX instance
:deactivate:  deactivate searX instance
:activate:    activate searX instance
:shell:       start interactive shell with user ${SEARX_USER}
:config:      isntall or diff searX configuration

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
    rstHeading "searX (${SEARX_INSTANCE_NAME})" part
}

_shell(){
    rstBlock "Quellen: ${SEARX_REPO_FOLDER} // Beenden mit STRG-D"
    sudo -H -u ${SEARX_USER} -i
}

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
        shell) _shell ;;
        info) less "${REPO_ROOT}/docs/searx.rst" ;;

        install)
            intro; sudoOrExit
            case $2 in
                server)  install_server ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;
        remove)
            intro; sudoOrExit
            case $2 in
                server)  remove_server ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;
        update)
            intro; sudoOrExit
            case $2 in
                server)  update_server ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;
        activate)
            intro; sudoOrExit
            case $2 in
                server)  activate_server ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;
        deactivate)
            intro; sudoOrExit
            case $2 in
                server)  deactivate_server ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;

        config)
            sudoOrExit
            case $2 in
                server)
		    intro
		    configure_searx
		    git_diff
		    uWSGI_restart
		    ;;
		diff)    git_diff ;;
                *)       arg2_unknown "$1" "$2"; exit 42;;
            esac ;;

        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}

# ----------------------------------------------------------------------------
install_server(){
     rstHeading "Installation searX"
# ----------------------------------------------------------------------------

    if ! askYn "Soll eine searX Instanz installiert werden?"; then
        return 42
    fi

    if ! print_URL_status https://localhost > /dev/null ; then
        rstBlock "Apache ist nicht installiert.  Die Installation sollte mit
dem Skript ./apache_setup.sh durchgeführt werden."
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    deactivate_server
    waitKEY

    TITLE='Installation erforderlicher Pakete' \
	 aptInstallPackages $SEARX_APT_PACKAGES

    assert_user
    clone_repo
    create_venv
    configure_searx
    test_local_searx

    rstHeading "Installation der uWSGI Konfiguration (searx.ini)" section
    echo
    uWSGI_install_app --eval $SEARX_UWSGI_APP

    install_apache_site

    test_public_searx
    info_msg "searX --> https://${SEARX_APACHE_DOMAIN}${SEARX_APACHE_URL}"
}

# ----------------------------------------------------------------------------
update_server(){
    rstHeading "Update searX Instanz" section
# ----------------------------------------------------------------------------

    echo
    TEE_stderr 0.5 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
cp -f ${SEARX_SETTINGS} ${SEARX_SETTINGS}.backup
git stash push -m "BACKUP -- 'update server' at ($(date))"
git checkout "$SEARX_GIT_BRANCH"
git pull origin "$SEARX_GIT_BRANCH"
${SEARX_REPO_FOLDER}/manage.sh update_packages
EOF
    configure_searx

    rstHeading "${SEARX_SETTINGS}" section
    rstBlock 'Differenz zw. der neuen Konfiguration (<) und der zuvor gesicherten (>):'
    echo
    diff ${SEARX_SETTINGS} ${SEARX_SETTINGS}.backup

    local action
    chooseOneMenu action "Was soll mit der Datei passieren?" \
           "Neue Konfiguration beibehalten." \
           "Alte Konfiguration (.backup Datei) wieder einspielen." \
           "Merge der beiden Dateien" \
	   "interaktiv mit git arbeiten"
    case $action in
        "Neue Konfiguration beibehalten.")
	    info_msg "Neue Konfiguration wird verwendet."
	    ;;
        "Alte Konfiguration (.backup Datei) wieder einspielen.")
	    TEE_stderr 2 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
cp -f ${SEARX_SETTINGS}.backup ${SEARX_SETTINGS}
EOF
	    ;;
        "Merge der beiden Dateien" )
	    $MERGE_CMD "${SEARX_SETTINGS}" "${SEARX_SETTINGS}.backup" "${SEARX_SETTINGS}"
	    ;;
	"interaktiv mit git arbeiten")
	    _shell
	    ;;
    esac
    chown ${SEARX_USER}:${SEARX_USER} "${SEARX_SETTINGS}"

    rstBlock 'Differenz zw. der Konfiguration (<) und dem Stand im Reposetory (>):'
    echo
    git_diff
    waitKEY
}

git_diff(){
    sudo -H -u ${SEARX_USER} -i <<EOF
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
git --no-pager diff
EOF
}

# ----------------------------------------------------------------------------
remove_server() {
    rstHeading "De-Installation searX"
# ----------------------------------------------------------------------------

    if ! askYn "Soll die searX Instanz deinstalliert werden?"; then
        return
    fi

    deactivate_server

    rstBlock "Die Konfiguration der searX App im uWSGI kann entfernt wuerden,
sofern keine indiviuellen Anpassungen vorgenommen wurden, die noch nicht
gesichert wurden."

    if askNy "Soll die searX App aus dem uWSGI entfernt werden?"; then
        uWSGI_remove_app $SEARX_UWSGI_APP
    fi

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
    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
sudo -H adduser \
  --disabled-password --gecos 'searX' \
  --home $SEARX_HOME $SEARX_USER
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
    rstHeading "Download/Clone der searX Sourcen" section
# ----------------------------------------------------------------------------

    rstBlock "Repository in ${SEARX_REPO_FOLDER}"
    echo
    CACHE="${SEARX_HOME}" SUDO_USER=$SEARX_USER\
	 cloneGitRepository "${SEARX_GIT_URL}"  "$(basename ${SEARX_REPO_FOLDER})"

    pushd "${SEARX_REPO_FOLDER}" > /dev/null

    # info_msg "create backup: $SEARX_SETTINGS.origin.backup"
    # git show "HEAD:searx/settings.yml" > "$SEARX_SETTINGS.origin.backup"

    TEE_stderr 0.2 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
cd ${SEARX_REPO_FOLDER}
git config user.email "${SEARX_USER}@${SEARX_APACHE_DOMAIN}"
git config user.name "searX on ${SEARX_APACHE_DOMAIN}"
git checkout "$SEARX_GIT_BRANCH"
EOF
    popd > /dev/null
    waitKEY
}

# ----------------------------------------------------------------------------
create_venv(){
    rstHeading "Bereitstellen der virtuellen Umgebung (python)" section
# ----------------------------------------------------------------------------

    rstBlock "Virtuelle Python Umgebung in ${SEARX_VENV}"
    echo
    TEE_stderr 0.2 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
rm -rf ${SEARX_VENV}
python3 -m venv ${SEARX_VENV}
. ${SEARX_VENV}/bin/activate
${SEARX_REPO_FOLDER}/manage.sh update_packages
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
configure_searx(){
    rstHeading "Konfiguration searX" section
# ----------------------------------------------------------------------------

    rstBlock "Virtuelle Python Umgebung in ${SEARX_VENV}"
    echo

    TEE_stderr 0.2 <<EOF | sudo -H -u ${SEARX_USER} -i | prefix_stdout
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" $SEARX_SETTINGS
sed -i -e "s/{instance_name}/${SEARX_INSTANCE_NAME}/g" $SEARX_SETTINGS
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
test_local_searx(){
# ----------------------------------------------------------------------------

    rstHeading "Test der searX Installation" section
    echo
    TEE_stderr <<EOF | sudo -i -u $SEARX_USER | prefix_stdout
. ${SEARX_VENV}/bin/activate
cd ${SEARX_REPO_FOLDER}
sed -i -e "s/debug : False/debug : True/g" $SEARX_SETTINGS
timeout 5 python3 searx/webapp.py &
sleep 1
curl --location --verbose --head --insecure http://127.0.0.1:8888/  2>&1
sed -i -e "s/debug : True/debug : False/g" $SEARX_SETTINGS
EOF
    waitKEY
}


# ----------------------------------------------------------------------------
test_public_searx(){
# ----------------------------------------------------------------------------

    rstHeading "Test des searX Dienst im WWW (public)" section
    echo
    waitKEY

    TEE_stderr <<EOF | bash | prefix_stdout
curl --location --head --insecure https://${SEARX_APACHE_DOMAIN}${SEARX_APACHE_URL}
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
install_apache_site(){
# ----------------------------------------------------------------------------

    rstHeading "Apache Site einrichten: ${SEARX_APACHE_SITE}" section
    echo
    a2enmod uwsgi
    APACHE_install_site --eval ${SEARX_APACHE_SITE}
    rstBlock "Dienst: https://${SEARX_APACHE_DOMAIN}${SEARX_APACHE_URL}"
    waitKEY

}

# ----------------------------------------------------------------------------
activate_server(){
    rstHeading "Aktivieren des searX (service)" section
# ----------------------------------------------------------------------------
    echo ""

    uWSGI_enable_app $SEARX_UWSGI_APP
    uWSGI_restart

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2ensite searx
systemctl force-reload apache2
EOF
}

# ----------------------------------------------------------------------------
deactivate_server(){
    rstHeading "De-Aktivieren des searX (service)" section
# ----------------------------------------------------------------------------
    echo ""

    uWSGI_disable_app $SEARX_UWSGI_APP
    uWSGI_restart

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2dissite searx
systemctl force-reload apache2
EOF
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
