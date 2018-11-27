#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Glances / cross-platform system monitoring (apache)
# ----------------------------------------------------------------------------
source $(dirname ${BASH_SOURCE[0]})/setup.sh

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# glances on localhost
GLANCES_PORT=61208
GLANCES_BIND=127.0.0.1

# systemd services
GLANCES_DESCRIPTION="Glances"
GLANCES_SYSTEMD_UNIT=/lib/systemd/system/glances.service
GLANCES_USER=glances
GLANCES_HOME=/home/${GLANCES_USER}

# Apache Redirect
GLANCES_APACHE_URL="/glances"
GLANCES_APACHE_SITE=glances

PYPI_PACKAGES="glances bottle"
DEB_PCKG="virtualenv python3 python3-dev"

# ----------------------------------------------------------------------------
# Config Backup
# ----------------------------------------------------------------------------

CONFIG_BACKUP=(
    "${GLANCES_SYSTEMD_UNIT}"
    "${APACHE_SITES_AVAILABE}/${GLANCES_APACHE_SITE}.conf"
)

CONFIG_BACKUP_ENCRYPTED=(
)

# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:

  $(basename $0) info
  $(basename $0) install    [server]
  $(basename $0) update     [server]
  $(basename $0) remove     [server]
  $(basename $0) activate   [server]
  $(basename $0) deactivate [server]

EOF
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "Glances" part
# ----------------------------------------------------------------------------

    _usage="${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;
        info) less "${REPO_ROOT}/docs/glances.rst" ;;

        install)
            sudoOrExit
            case $2 in
                server)  setup_glances_server ;;
                *)       usage $_usage; exit 42;;
            esac ;;
        update)
            sudoOrExit
            case $2 in
                server)  update_glances ;;
                *)       usage $_usage; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                server)  remove_glances ;;
                *)       usage $_usage; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  activate_server ;;
                *)       usage $_usage; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server ;;
                *)       usage $_usage; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}


# ----------------------------------------------------------------------------
setup_glances_server(){
    rstHeading "Installation Glances"
# ----------------------------------------------------------------------------

    rstBlock "Es wird Glances eingerichtet mit einem Apache ReverseProxy"

    if ! aptPackageInstalled apache2; then
        rstBlock "Apache ist noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    rstBlock "Die Installation des Monitoring Werkzeugs Glances ${BRed}wird nur
im Intranet empfohlen${_color_Off}."

    if ! askYn "Soll Glances installiert werden?"; then
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    deactivate_server

    if aptPackageInstalled glances; then
        if [[ -f /etc/init.d/glances || -f /etc/glances/glances.conf ]] ; then
           rstBlock "Es wurde bereits das Paket 'glances' installiert. Die \
/etc/init.d/glances aus dem Paket ist veraltet und passt nicht zu dem hier \
einzurichtenden Dienst und wird nun gelöscht."
           waitKEY
           rm -f /etc/init.d/glances
        fi
    fi

    rstHeading "Benötigte System Pakete" section
    rstPkgList ${DEB_PCKG}
    echo
    apt-get install -y ${DEB_PCKG}
    waitKEY

    assert_user
    install_glances

    rstHeading "Install System-D Unit glances.service ..." section
    TEMPLATES_InstallOrMerge --eval ${GLANCES_SYSTEMD_UNIT} root root 644
    waitKEY

    rstHeading "Apache Site mit ProxyPass einrichten" section
    echo
    a2enmod proxy_http
    APACHE_install_site --eval ${GLANCES_APACHE_SITE}

    activate_server

    rstBlock "Dienst ist eingerichtet ..."
    rstBlock "  --> https://${APACHE_SERVER_NAME}${GLANCES_APACHE_URL}"
    waitKEY
}


install_glances(){
    rstHeading "Install Glances (user's HOME)" section
    rstPkgList  ${PYPI_PACKAGES}
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
cd ${GLANCES_HOME}
virtualenv --python=python3 py3
source ${GLANCES_HOME}/py3/bin/activate
pip install -U pip setuptools
pip install ${PYPI_PACKAGES}
EOF
    TEMPLATES_InstallOrMerge /etc/glances/glances.conf root root 644
    waitKEY
}

assert_user(){
    rstHeading "Benutzer $GLANCES_USER" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
sudo adduser --shell /usr/sbin/nologin --disabled-password --home $GLANCES_HOME --gecos 'Glances' $GLANCES_USER
groups $GLANCES_USER
EOF
    export GGLANCES_HOME="$(sudo -i -u $GLANCES_USER echo \$HOME)"
    rstBlock "export GLANCES_HOME=$GLANCES_HOME" | prefix_stdout
    waitKEY
}

# ----------------------------------------------------------------------------
activate_server(){
    rstHeading "Aktivieren des Glances (service)" section
# ----------------------------------------------------------------------------
    echo ""
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2ensite ${GLANCES_APACHE_SITE}
systemctl force-reload apache2
systemctl enable glances.service
systemctl restart glances.service
EOF
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl status glances.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server(){
    rstHeading "De-Aktivieren des Glances (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
a2dissite ${GLANCES_APACHE_SITE}
systemctl force-reload apache2
systemctl stop glances.service
systemctl disable glances.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
remove_glances() {
    rstHeading "De-Installation Glances"
# ----------------------------------------------------------------------------

    if ! askYn "Soll Glances deinstalliert werden?"; then
        return
    fi
    deactivate_server
    rm -f "${GLANCES_SYSTEMD_UNIT}"
    rm -f "${APACHE_SITES_AVAILABE}/${GLANCES_APACHE_SITE}.conf"
    systemctl force-reload apache2

    rstHeading "Benutzer $GLANCES_USER" section
    userdel -r -f "$GLANCES_USER"
}

# ----------------------------------------------------------------------------
update_glances() {
    rstHeading "Update Glances"
# ----------------------------------------------------------------------------

    rstBlock "Das Update besteht aus eine Systemupdate und einer erneuten Installation des glances"
    if ! askYn "Update durchführen?"; then
        return 42
    fi

    rstHeading "Update des Systems" section

    apt-get update -y
    apt-get dist-upgrade -y
    apt-get autoclean -y
    apt-get autoremove -y

    deactivate_server

    rstHeading "Update Glances" section
    rstBlock "Update mittels deinstallation und installation aktueller Version"
    remove_glances
    install_glances

    activate_server
    waitKEY 10
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
