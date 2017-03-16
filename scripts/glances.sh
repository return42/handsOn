#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Glances / cross-platform system monitoring (apache)
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# Rverse Proxy with prefix URL e.g.: https:/myhost.org/glances did not work?
#
# https://github.com/nicolargo/glances/wiki/Start-Glances-through-Systemd
# https://github.com/nicolargo/glances/wiki/Reverse-proxy-to-the-Glances-Web-UI

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

WSGI_APPS="${WWW_FOLDER}/pyApps"
PYENV=pyenv

PYPI_PACKAGES="Glances Bottle"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Glances" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
            install_glances
	    ;;
	deinstall)
            deinstall_glances
	    ;;
	*)
            echo
	    echo "usage $0 [(de)install]"
            echo
            ;;
    esac
}
# ----------------------------------------------------------------------------
install_glances(){
    rstHeading "Installation Glances"
# ----------------------------------------------------------------------------

    rstBlock "Die Installation des Monitoring Werkzeugs Glances ${BRed}wird nur
im Intranet empfohlen${_color_Off}."

    if ! askYn "Soll Glances installiert werden?"; then
        return 42
    fi

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache is noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi
    systemctl stop glances.service

    source ${WSGI_APPS}/${PYENV}/bin/activate
    pip install ${PYPI_PACKAGES}
    TEMPLATES_InstallOrMerge /lib/systemd/system/glances.service root root 644

    systemctl enable glances.service
    systemctl start glances.service

    rstBlock " --> http://$HOSTNAME:61208/<refresh in sec.>"
}

# ----------------------------------------------------------------------------
deinstall_glances(){
    rstHeading "De-Installation Glances"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG:${_color_Off}"
    if ! askNy "  Wollen sie WIRKLICH Glances deinstallieren?"; then
        return 42
    fi

    systemctl stop glances.service
    systemctl disable glances.service
    rm /lib/systemd/system/glances.service

    source ${WSGI_APPS}/${PYENV}/bin/activate
    pip uninstall ${PYPI_PACKAGES}
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
