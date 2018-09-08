#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     gogs.sh
# -- Copyright (C) 2018 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     Gogs Installation mit SQLite DB
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GO_PKG_URL=https://dl.google.com/go/go1.11.linux-amd64.tar.gz
GO_TAR="$(basename https://dl.google.com/go/go1.11.linux-amd64.tar.gz)"

GOGS_DESCRIPTION="Gogs (Go Git Service)"
GOGS_USER=gogs

GOGS_SYSTEMD_UNIT=/lib/systemd/system/gogs.service


# Den HOME Ordner sollte man nicht ändern, er (/home/gogs) wird auch in den
# Konfigurationen verwendet.
GOGS_HOME=/home/gogs

# Domain in welcher der Gogs Server lauscht:
GOGS_DOMAIN=127.0.0.1

# Apache Redirect URL
GOGS_APACHE_DOMAIN="$(uname -n)"
GOGS_APACHE_URL="/gogs"

# Port für den Gogs Server auf dem localhost
GOGS_PORT=3000
# Die URI muss sein 'github.com/gogs/gogs' nicht '...gogits/gogs' wie in einigen
# älteren Dokumentationen zu finden. Siehe ChangeLog 0.11.53@2018-06-05:
#
# - https://gogs.io/docs/intro/change_log#0.11.53-%40-2018-06-05
#
GOGS_URI=github.com/gogs/gogs

#GOGS_PACKAGES="\
#"

CONFIG_BACKUP=(
    "${GOGS_SYSTEMD_UNIT}"
    "/home/gogs/local/gogs/custom/conf/app.ini"
)

CONFIG_BACKUP_ENCRYPTED=(
)


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------
    cat <<EOF

$1

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
        info) less "${REPO_ROOT}/docs/gogs.rst" ;;
        install)
            sudoOrExit
            case $2 in
                server)  setup_gogs_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                server)  remove_gogs ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        activate)
            sudoOrExit
            case $2 in
                server)  activate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        deactivate)
            sudoOrExit
            case $2 in
                server)  deactivate_server ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}


# ----------------------------------------------------------------------------
setup_gogs_server(){
    rstHeading "Installation Gogs"
# ----------------------------------------------------------------------------

    rstBlock "Es wird Gogs mit einer SQLite Datenbank eingerichtet"

    if ! aptPackageInstalled apache2; then
        rstBlock "Apache ist noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    if ! askYn "Soll Gogs installiert werden?"; then
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    deactivate_server

    # Wenn man go eh neu installiert hat, dann braucht man hier im System kein
    # golang Paket (das wäre ja die alte Installation, also 1.6 bei Ubuntu 16.04).
    #
    # aptInstallPackages golang libpam0g-dev libsqlite3-0
    aptInstallPackages libpam0g-dev libsqlite3-0

    assert_user
    install_go

    download_gogs
    build_gogs
    install_gogs
    TEMPLATES_InstallOrMerge --eval /home/gogs/local/gogs/custom/conf/app.ini root root 644
    waitKEY

    rstHeading "Test der Gogs Installation" section
    echo
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
source ~/.env_gogs
timeout 20 \$HOME/local/gogs/gogs web &
sleep 5
curl --location --verbose --head --insecure http://$GOGS_DOMAIN:$GOGS_PORT 2>&1
EOF
    waitKEY

    rstHeading "Install System-D Unit gogs.service ..." section
    TEMPLATES_InstallOrMerge --eval ${GOGS_SYSTEMD_UNIT} root root 644
    waitKEY
    activate_server

    rstHeading "Apache Site mit ProxyPass einrichten" section
    echo
    a2enmod proxy_http
    APACHE_install_site --eval gogs
    rstBlock "Dienst: https://${GOGS_APACHE_DOMAIN}${GOGS_APACHE_URL}"
    waitKEY

    rstHeading "Test des Gogs Dienstes im WWW" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
curl --location --verbose --head --insecure https://${GOGS_APACHE_DOMAIN}${GOGS_APACHE_URL}
EOF
    waitKEY

}


install_go(){
    rstHeading "Install Go in user's HOME" section

    rstBlock "Es wird ein aktuelles Go binary heruntergeladen und installiert..."
    cacheDownload "${GO_PKG_URL}" "${GO_TAR}"

    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
echo \$HOME
rm -rf \$HOME/local/go
mkdir -p \$HOME/local
tar -C \$HOME/local -xzf ${CACHE}/${GO_TAR}
EOF

    rstBlock "${GO_TAR} wurde nach $GOGS_HOME/go entpackt"
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
source ~/.env_gogs
env
! which go &&  echo "Go Installation not found in PATH!?!"
which go &&  echo "congratulations, Go Installation OK :)"
EOF
    waitKEY
}

assert_user(){

    rstHeading "Benutzer $GOGS_USER" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
sudo adduser --shell /bin/bash --system --home $GOGS_HOME --group --gecos 'Gogs' $GOGS_USER
EOF
    export GOGS_HOME="$(sudo -i -u $GOGS_USER echo \$HOME)"
    rstBlock "export GOGS_HOME=$GOGS_HOME" | prefix_stdout

    cat > $GOGS_HOME/.env_gogs <<EOF
export PATH=\$PATH:\$HOME/local/go/bin:\$HOME/local/gogs
export GOPATH=\$HOME/go-apps
EOF
    rstBlock "Umgebung $GOGS_HOME/.env_gogs wurde angelegt"
    waitKEY

}


download_gogs(){
    rstHeading "Download Gogs" section
    echo
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
source ~/.env_gogs
mkdir -p "\${GOPATH}"
go get -v -u -tags "sqlite pam" $GOGS_URI
EOF
    waitKEY
}

build_gogs(){
    rstHeading "Build Gogs" section
    echo
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
source ~/.env_gogs
cd "\${GOPATH}/src/$GOGS_URI"
pwd
go build -v -tags "sqlite pam"
EOF
    waitKEY
}

install_gogs(){
    rstHeading "Install Gogs (user's HOME)" section
    echo
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
source ~/.env_gogs
cd "\${GOPATH}/src/$GOGS_URI"
rm -rf \$HOME/local/gogs
mkdir -p \$HOME/local/gogs/custom/conf
cp -fr gogs LICENSE public README.md README_ZH.md scripts templates \$HOME/local/gogs
EOF
    waitKEY
}


# ----------------------------------------------------------------------------
remove_gogs() {
    rstHeading "De-Installation Gogs"
# ----------------------------------------------------------------------------

    if ! askYn "Soll Gogs deinstalliert werden?"; then
        return
    fi
    deactivate_server
    rm "${GOGS_SYSTEMD_UNIT}"

    rstHeading "Benutzer $GOGS_USER" section
    if askNy "Soll der Benutzer wirklich ganz gelöscht werden? Alle Daten gehen verloren!!!"; then
        userdel -r -f "$GOGS_USER"
    else
        rstBlock "Benutzerdaten [$(du -sh $GOGS_HOME)] bleiben erhalten."
    fi

}




# ----------------------------------------------------------------------------
activate_server(){
    rstHeading "Aktivieren des Gogs (service)" section
# ----------------------------------------------------------------------------
    echo ""
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl enable gogs.service
systemctl restart gogs.service
EOF
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl status gogs.service
EOF
    waitKEY 10
}

# ----------------------------------------------------------------------------
deactivate_server(){
    rstHeading "De-Aktivieren des Gogs (service)" section
# ----------------------------------------------------------------------------
    echo ""

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
systemctl stop gogs.service
systemctl disable gogs.service
EOF
    waitKEY 10
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
