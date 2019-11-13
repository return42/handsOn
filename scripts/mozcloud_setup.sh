#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-

if [[ "$1" != "--" ]]; then
    source $(dirname ${BASH_SOURCE[0]})/setup.sh
fi

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

MOZCLOUD_DOMAIN=$HOSTNAME  # e.g. example.com

MOZCLOUD_USER=mozcloud
MOZCLOUD_USER_GECOS="Mozilla Cloud"
MOZCLOUD_USER_HOME_FOLDER="/home/${MOZCLOUD_USER}"

# für gunicorn:
GUNICORN_HOST="localhost"
GUNICORN_PORT=5000
GUNICORN_PUBLIC_URL_IN_FFOX="http://${GUNICORN_HOST}:${GUNICORN_PORT}"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Basis Setup der Mozilla-Cloud" part
# ----------------------------------------------------------------------------

    case $1 in

        installMozCloudEnv)
            installMozCloudEnv
            ;;
        addMozCloudUser)
            addMozCloudUser
            ;;
        installMozCloudPackages)
            installMozCloudPackages
            ;;
	*)
            USAGE
            ;;
    esac
}

# ----------------------------------------------------------------------------
USAGE () {
# ----------------------------------------------------------------------------

    echo -e "
usage:

  $(basename $0) <command>

commands:

* installMozCloudEnv: MozCloud Umgebung (bestehend aus User und Paketen)
* addMozCloudUser : Einrichten des Benutzers ${MOZCLOUD_USER}
* installMozCloudPackages: Installation der erforderlichen Entwickler Pakete
"
}

# ----------------------------------------------------------------------------
installMozCloudPackages(){
# ----------------------------------------------------------------------------

    local PACKAGES="python-dev git-core python-virtualenv g++"

    rstHeading "Für MozCloud erforderliche Entwickler Pakete im OS"
    sudoOrExit

    rstBlock "Vor der Installation des Sync-Servers müssen ein paar
Entwickler-Pakete im System installiert werden."

    rstPkgList ${PACKAGES}
    echo
    waitKEY 20
    apt-get install -y ${PACKAGES}
    waitKEY 20
}

# ----------------------------------------------------------------------------
addMozCloudUser(){
# ----------------------------------------------------------------------------

    rstHeading "Einrichten des Benutzers ${MOZCLOUD_USER}"
    sudoOrExit

    if [[ ! $(id ${MOZCLOUD_USER}) ]] 2>/dev/null ; then
        echo
        sudo -H adduser --system --disabled-password --disabled-login \
             --shell /bin/bash \
             --gecos "$MOZCLOUD_USER_GECOS" \
             ${MOZCLOUD_USER}
    else
        rstBlock "Benutzer ${MOZCLOUD_USER} existiert bereits:"
    fi
    echo
    echo id ${MOZCLOUD_USER} | TEE_stderr | bash | prefix_stdout
    userMozCloudOrExit
}

# ----------------------------------------------------------------------------
userMozCloudOrExit(){
# ----------------------------------------------------------------------------

    if [[ "$(id -u --name)" == "$MOZCLOUD_USER" ]]; then
        return
    fi
    echo -e "
Die Installation und Wartung der Mozilla Cloud Infrastruktur kann nur von dem
System-User '${MOZCLOUD_USER}' durchgeführt werden. Ein Wechsel zu dem
System-User kann wie folgt durchgeführt werden:: ${Yellow}

  $ sudo -i -u ${MOZCLOUD_USER}
  $ ${REPO_ROOT}/HOWTOs/$(basename $0) <command>
${_color_Off}"
    exit 42
}

# ----------------------------------------------------------------------------
installMozCloudEnv(){
# ----------------------------------------------------------------------------

    sudoOrExit
    installMozCloudPackages
    addMozCloudUser
    waitKEY
}

# ----------------------------------------------------------------------------
if [[ "$1" != "--" ]]; then
    main "$@"
fi
# ----------------------------------------------------------------------------
