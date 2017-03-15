#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Radicale: WSGI CalDAV & CardDAV Server (apache)
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

WSGI_APPS="${WWW_FOLDER}/pyApps"
PYENV=pyenv

RADICALE_GIT_URL="https://github.com/Kozea/Radicale.git"
RADICALE_DATA_FOLDER="$WSGI_APPS/Radicale.data"
RADICALE_REPO_FOLDER="$WSGI_APPS/Radicale"

DATA_BACKUP=(
    "$RADICALE_DATA_FOLDER"
)

# ----------------------------------------------------------------------------
main(){
    rstHeading "Radicale" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
            install_radicale
	    ;;
	deinstall)
            deinstall_radicale
	    ;;
            ;;
	*)
            echo
	    echo "usage $0 [(de)install]"
            echo
            ;;
    esac
}
# ----------------------------------------------------------------------------
install_radicale(){
    rstHeading "Installation Radicale"
# ----------------------------------------------------------------------------

    README_GITLAB
    if ! askYn "Soll Radicale installiert werden?"; then
        return 42
    fi

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache is noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    cloneGitRepository "${RADICALE_GIT_URL}" "${RADICALE_REPO_FOLDER}"
    TEMPLATES_InstallOrMerge /var/www/pyApps/Radicale/radicale.wsgi root root 644
    source ${WSGI_APPS}/${PYENV}/bin/activate
    pip install vobject

    APACHE_install_site radicale

    rstBlock "

  https://$HOSTNAME/radicale/<username>
"

}


# ----------------------------------------------------------------------------
deinstall_gitlab(){
    rstHeading "Radicale"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG:${_color_Off}

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

* Anwendungsdaten: ${BYellow}${RADICALE_DATA_FOLDER}${_color_Off}
* Reposetorie:     ${BYellow}${RADICALE_REPO_FOLDER}${_color_Off}

Diese müssen ggf. gesichert und anschließend gelöscht werden."

    waitKEY

}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
