#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Radicale: WSGI CalDAV & CardDAV Server (apache)
# ----------------------------------------------------------------------------

source "$(dirname "${BASH_SOURCE[0]}")/setup.sh"

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

WSGI_APPS="${WWW_FOLDER}/pyApps"
PYENV=pyenv

RADICALE_LOG_FOLDER=/var/log/radicale
RADICALE_GIT_URL="https://github.com/return42/Radicale.git"
RADICALE_DATA_FOLDER="$WSGI_APPS/Radicale.data"
RADICALE_REPO_FOLDER="$WSGI_APPS/Radicale"

RADICALE_WEB_GIT_URL="https://github.com/return42/RadicaleWeb.git"
RADICALE_WEB_REPO_FOLDER="$WSGI_APPS/RadicaleWeb"

RADICALE_REQUIRE=(
  vobject
)

DATA_BACKUP=(
    "$RADICALE_DATA_FOLDER"
)

CONFIG_BACKUP=(
    "/etc/radicale"
)

# ----------------------------------------------------------------------------
main(){
    rstHeading "Radicale" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
            sudoOrExit
            install_radicale
	    ;;
	deinstall)
            sudoOrExit
            deinstall_radicale
	    ;;
        README)
             cat \
                 ${REPO_ROOT}/docs/radicale/radicale_server.rst \
                 ${REPO_ROOT}/docs/radicale/dav_client.rst \
                 | grep -v "^\.\." | less
            ;;
	*)
            echo
	    echo "usage $0 [(de)install|README]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
install_radicale(){
    rstHeading "Installation Radicale"
# ----------------------------------------------------------------------------

    if ! askYn "Soll Radicale installiert werden?"; then
        return 42
    fi

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache is noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    mkdir -p "${RADICALE_REPO_FOLDER}"
    # shellcheck disable=SC1007
    SUDO_USER= cloneGitRepository "${RADICALE_GIT_URL}" "${RADICALE_REPO_FOLDER}"
    # shellcheck disable=SC1007
    SUDO_USER= cloneGitRepository "${RADICALE_WEB_GIT_URL}" "${RADICALE_WEB_REPO_FOLDER}"
    mkdir -p "/etc/radicale/"
    TEMPLATES_InstallOrMerge /var/www/pyApps/radicale.wsgi root root 644
    TEMPLATES_InstallOrMerge /etc/radicale/config root root 644
    TEMPLATES_InstallOrMerge /etc/radicale/logging root root 644
    TEMPLATES_InstallOrMerge /etc/radicale/rights root root 644
    mkdir -p "${RADICALE_LOG_FOLDER}"
    chown -R www-data:nogroup "${RADICALE_LOG_FOLDER}"
    mkdir -p "${RADICALE_DATA_FOLDER}"
    chown -R www-data:nogroup "${RADICALE_DATA_FOLDER}"

    source "${WSGI_APPS}/${PYENV}/bin/activate"
    pip install "${RADICALE_REQUIRE[@]}"

    APACHE_install_site radicale

    rstBlock "

  https://$HOSTNAME/radicale/<username>
"

}

# ----------------------------------------------------------------------------
deinstall_radicale(){
    rstHeading "De-Installation Radicale"
# ----------------------------------------------------------------------------

    rstBlock "${BRed:?}ACHTUNG:${_color_Off:?}

    Folgende Aktion löscht die Radicale samt Konfiguration!"

    if ! askNy "Wollen sie WIRKLICH die Konfiguration löschen?"; then
        return 42
    fi

    rstHeading "Apache Site *disable*" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
a2dissite radicale
systemctl force-reload apache2
EOF

    rstHeading "Aufräumen" section

    echo -e "
Folgende Dateien bzw. Ordner wurden nicht gelöscht:

* Anwendungsdaten: ${BYellow:?}${RADICALE_DATA_FOLDER}${_color_Off:?}
* Reposetorie:     ${BYellow:?}${RADICALE_REPO_FOLDER}${_color_Off:?}
* Log-Dateien:     ${RADICALE_LOG_FOLDER}
Diese müssen ggf. gesichert und anschließend gelöscht werden."

    waitKEY

}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
