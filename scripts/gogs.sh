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

# https://blog.cadena-it.com/linux-tips-how-to/gogs-on-ubuntu-16-04/

# Auf dem Server ist ein steinaltes Go, da muss man was aktuelles installieren:
#  https://tecadmin.net/install-go-on-ubuntu/
#
# Noch einfacher ist es evtl. das tar einfach in den ~gogs/go Pfad hin
# auszupacken.
#
# https://golang.org/doc/install?download=go1.11.linux-amd64.tar.gz

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GO_PKG_URL=https://dl.google.com/go/go1.11.linux-amd64.tar.gz
GO_TAR="$(basename https://dl.google.com/go/go1.11.linux-amd64.tar.gz)"

GOGS_USER=gogs

# Den HOME Ordner sollte man nicht ändern, er (/home/gogs) wird auch in den
# Konfigurationen verwendet.
GOGS_HOME=/home/gogs

# Die URI muss sein 'github.com/gogs/gogs' nicht '...gogits/gogs' wie in einigen
# älteren Dokumentationen zu finden.
GOGS_URI=github.com/gogs/gogs

#GOGS_PACKAGES="\
#"

CONFIG_BACKUP=(
    # "/lib/systemd/system/gogs.service"
)

CONFIG_BACKUP_ENCRYPTED=(
)


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------
    cat <<EOF

$1

usage:

  $(basename $0) install    [gogs]
  $(basename $0) remove     [gogs]
  $(basename $0) activate   [server]
  $(basename $0) deactivate [server]

EOF
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "Gogs / Go Git Service" part
# ----------------------------------------------------------------------------

    case $1 in
        install)
            sudoOrExit
            case $2 in
                gogs)  install_gogs ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing install command $2"; exit 42;;
            esac ;;
        remove)
            sudoOrExit
            case $2 in
                gogs)  remove_gogs ;;
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
install_gogs(){
    rstHeading "Installation Gogs"
# ----------------------------------------------------------------------------

    rstBlock "Es wird Gogs mit einer SQLite Datenbank eingerichtet"

    if ! askYn "Soll Gogs installiert werden?"; then
        return 42
    fi

    rstBlock "Eine ggf. vorhandene Installation wird nun runter gefahren."
    deactivate_server

    echo -e "
Die Installation bedarf einiger Vorbereitung und erfolgt in folgenden Schritten:

1. Es werden die erforderlichen Systempakete installiert
2. Es wird der Benutzer '$GOGS_USER' angelegt
3. In dessen HOME Ordner erfolgt eine aktuelle Go Installation.
4. Es wird gogs heruntergeladen und in HOME installiert.
"
    waitKEY

    # Wenn man go eh neu installiert hat, dann braucht man hier im System kein
    # golang Paket (das wäre ja die alte Installation, also 1.6 bei Ubuntu 16.04).
    #
    # aptInstallPackages golang libpam0g-dev libsqlite3-0
    aptInstallPackages libpam0g-dev libsqlite3-0

    _assert_user
    _assert_go
    _assert_gogs

    waitKEY
}


_assert_go(){
    rstHeading "Install Go in user's HOME" section

    rstBlock "Es wird ein aktuelles Go binary heruntergeladen und installiert..."
    cacheDownload "${GO_PKG_URL}" "${GO_TAR}"

    TEE_stderr 1 <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
echo \$HOME
rm -rf \$HOME/local/go
mkdir -p \$HOME/local
tar -C \$HOME/local -xzf ${CACHE}/${GO_TAR}
EOF

    rstBlock "${GO_TAR} wurde nach $GOGS_HOME/go entpackt"
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
export PATH=\$PATH:\$HOME/local/go/bin
export GOPATH="\$HOME/go/"
env
! which go &&  echo "Go Installation not found in PATH!?!"
which go &&  echo "congratulations, Go Installation OK :)"
EOF
    waitKEY
}

_assert_user(){

    rstHeading "Benutzer $GOGS_USER" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
sudo adduser --shell /bin/bash --system --home $GOGS_HOME --group --gecos 'Gogs' $GOGS_USER
EOF
    export GOGS_HOME="$(sudo -i -u $GOGS_USER echo \$HOME)"
    rstBlock "export GOGS_HOME=$GOGS_HOME" | prefix_stdout
    # sollte immer /home/gogs sein
    waitKEY

}

_assert_gogs(){

    rstHeading "Download Gogs" section
    echo
    TEE_stderr 1 <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
export PATH=\$PATH:\$HOME/local/go/bin
export GOPATH="\$HOME/go/"
env
mkdir -p "\${GOPATH}"
go get -v -u -tags "sqlite pam" $GOGS_URI
EOF
    waitKEY

    rstHeading "Build Gogs" section
    echo
    TEE_stderr 1 <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
export PATH=\$PATH:\$HOME/local/go/bin
export GOPATH="\$HOME/go/"
cd "\${GOPATH}/src/$GOGS_URI"
pwd
go build -v -tags "sqlite pam"
EOF
    waitKEY

    rstHeading "Install Gogs (user's HOME)" section
    echo
    TEE_stderr 1 <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
export PATH=\$PATH:\$HOME/local/go/bin
export GOPATH="\$HOME/go/"
cd "\${GOPATH}/src/$GOGS_URI"
pwd
# alte Installation löschen ...
rm -rf \$HOME/local/gogs

# neu installieren ...
mkdir -p \$HOME/local/gogs/custom/conf
cp -fr gogs LICENSE public README.md README_ZH.md scripts templates \$HOME/local/gogs

# app.ini aus den Vorlagen übernehmen ...
cp ${TEMPLATES}/home/gogs/local/gogs/custom/conf/app.ini \$HOME/local/gogs/custom/conf
ls -la \$HOME/local/gogs
EOF
    waitKEY

    rstHeading "Test Gogs binary ..." section
    echo
    TEE_stderr <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
\$HOME/local/gogs/gogs web --help
EOF
    waitKEY

    rstBlock "\
Der Gogs Dienst wird am einfachsten initial über die WEB-gui installiert
(http://$(uname -n):3000).  Bei einer Installation im Internet sollte die
Installation über die WEB-gui umgehend erfolgen (bevor ein *Anderer* darauf
zugreift).

In der WEB-gui wählt man SQlite3 aus und trägt beim 'Run User' noch gogs (statt
git) ein. Alles Andere beläßt man bei den Defaults, wie localhost und Port 3000.
Dienst wird initial gestartet (nach Abschluss WEB-gui mit STRG-C abbrechen) .."

    rstBlock " --> http://$(uname -n):3000"

    TEE_stderr 3 <<EOF | sudo -i -u $GOGS_USER | prefix_stdout
\$HOME/local/gogs/gogs web &
curl --location --verbose --head --insecure http://localhost:3111 2>&1
sleep 20
EOF
    waitKEY


# Type=simple
# User=gogs
# Group=gogs
# WorkingDirectory=/home/gogs
# ExecStart=/home/gogs/local/gogs/gogs web
# Restart=always
# Environment=USER=gogs HOME=/home/gogs GOGS_CUSTOM=/home/gogs/local/gogs
/home/gogs/local/gogs/custom

    
    rstHeading "Install System-D Unit gogs.service ..." section

    TEMPLATES_InstallOrMerge /lib/systemd/system/gogs.service root root 644
    activate_server

    rstBlock "Dienst ist eingerichtet ..."
    rstBlock "  --> http://$HOSTNAME:3000"

    

    jetzt kann schon getestet werden .. evtl. jetzt schon den Dienst installieren nund starten.
    





    rstHeading "Install gogs in user's home" section


    FIXME: hier liegt der gogs Ordner: "\${GOPATH}/src/$GOGS_URI"

    
    echo "FIXME ...."
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
    rm /lib/systemd/system/gogs.service

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
