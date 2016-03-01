#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-

source $(dirname ${BASH_SOURCE[0]})/setup.sh
source $(dirname ${BASH_SOURCE[0]})/mozcloud_setup.sh --
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# Sync-1,5 Server
# ---------------

SYNC_SERVER_GIT_URL="https://github.com/mozilla-services/syncserver"
SYNC_SERVER_FOLDER="syncserver"
SYNC_SERVER_DB="sqlite:////${MOZCLOUD_USER_HOME_FOLDER}/${SYNC_SERVER_FOLDER}/syncserver.db"
SYNC_SERVER_INI="${MOZCLOUD_USER_HOME_FOLDER}/${SYNC_SERVER_FOLDER}/syncserver.ini"
SYNC_SERVER_APACHE_SITE="fxSyncServer.conf"

# für Apache
PUBLIC_URL_IN_FFOX="https://${MOZCLOUD_DOMAIN}/fxSyncServer"


# ----------------------------------------------------------------------------
main(){
    rstHeading "Sync-1.5 Server mit public accounts" part
# ----------------------------------------------------------------------------

    case $1 in

        installMozCloudEnv)
            installMozCloudEnv
            ;;
        installSyncServer)
            installSyncServer
            ;;
        updateSyncServer)
            updateSyncServer
            ;;
        runSyncServer)
            runSyncServer
            ;;
        installApacheSite)
            installApacheSite
            ;;
	*)
            USAGE
            ;;
    esac
}


# ----------------------------------------------------------------------------
USAGE(){
# ----------------------------------------------------------------------------

    echo -e "
usage:

  $(basename $0) <command>

commands:

* installMozCloudEnv: MozCloud Umgebung (bestehend aus User und Paketen)
* installSyncServer:  Install Sync-1.5 Server
* updateSyncServer:   Update Sync-1.5 Server
* runSyncServer:      test / debug : run Sync-1.5 Server on console
* installApacheSite:  Install Apache-Site for Sync-1.5 Server
"
}

# ----------------------------------------------------------------------------
installApacheSite(){
# ----------------------------------------------------------------------------

    rstHeading "Sync-1.5 Server im Apache installieren"

    sudoOrExit

    rstHeading "Site ${SYNC_SERVER_APACHE_SITE}" section
    if askNy "Soll die *Site* im Apache eingerichtet werden?" ; then
	APACHE_install_site "${SYNC_SERVER_APACHE_SITE}"

        rstBlock "Der Sync-1.5 Server ist als Site im Apache eingerichtet. Über
die folgende URL:

* ${PUBLIC_URL_IN_FFOX}/token/1.0/sync/1.5

müsste nun eine JSON Ausgabe::

   {'status': 'error', 'errors': [{'location': 'body', 'name': '', 'description': 'Unauthorized'}]}

im WEB-Browser angezeigt werden. Sollte am Ende so etwas wie::

  .. 'description': 'Unsupported'

stehen, dann klappt noch etwas mit dem URL-Dispatching evtl. nicht. Das kann
u.U. passieren, wenn ${PUBLIC_URL_IN_FFOX} nicht der *root* Pfad ist.

In den Firefox Einstellungen (about:config) muss der SyncServer eingetragen
werden:

* identity.sync.tokenserver.uri", "${PUBLIC_URL_IN_FFOX}/token/1.0/sync/1.5
"
    fi

    waitKEY
}



# ----------------------------------------------------------------------------
_gitPull(){
# ----------------------------------------------------------------------------

    local gitUrl="$1"
    local gitFolder="${MOZCLOUD_USER_HOME_FOLDER}/$2"

    if [[ -d "$gitFolder" ]] ; then
	echo -e "${Green}already cloned:${_color_Off} $1"
        echo -e "  -->${Green} $gitFolder ${_color_Off}"
	pushd "$gitFolder" > /dev/null
        git pull --all
	popd > /dev/null
    else
	echo -e "${Green}clone:${_color_Off} $1"
        echo -e "  -->${Green} $gitFolder ${_color_Off}"
        git clone "$gitUrl" "$gitFolder"
    fi

}

# ----------------------------------------------------------------------------
installSyncServer(){
# ----------------------------------------------------------------------------

    local _secret="$(head -c 20 /dev/urandom | sha1sum)"

    rstHeading "Firefox SyncServer"
    userMozCloudOrExit

    rstBlock "Es wird der Firefox Sync-1.5 Server eingerichtet. Die Installation
erfolgt (lokal) unter dem Benutzer *${MOZCLOUD_USER}* (in dessen HOME-Ordner).
Es wird das Git-reposeory des Sync-1.5 Server geklont und darin wird der Build
Prozess aufgerufen.

* https://docs.services.mozilla.com/howtos/run-sync-1.5.html"

    rstHeading "clone / update " section
    echo
    _gitPull "${SYNC_SERVER_GIT_URL}" "${SYNC_SERVER_FOLDER}"
    waitKEY 20

    pushd "${MOZCLOUD_USER_HOME_FOLDER}/${SYNC_SERVER_FOLDER}" > /dev/null

    rstHeading "build Sync-1.5 Server" section
    echo
    make build
    waitKEY

    rstHeading "test Sync-1.5 Server" section
    echo
    make test
    waitKEY

    popd > /dev/null

    rstHeading "Setup Sync-1.5 Server" section

    # gunicorn [server:main]
    setValueCfgFile "${SYNC_SERVER_INI}" host ${GUNICORN_HOST}
    setValueCfgFile "${SYNC_SERVER_INI}" port ${GUNICORN_PORT}
    #setValueCfgFile "${SYNC_SERVER_INI}" workers 2
    #setValueCfgFile "${SYNC_SERVER_INI}" timeout 30

    # wsgi app [app:main]
    setValueCfgFile "${SYNC_SERVER_INI}" public_url ${PUBLIC_URL_IN_FFOX}
    setValueCfgFile "${SYNC_SERVER_INI}" sqluri "${SYNC_SERVER_DB}"
    setValueCfgFile "${SYNC_SERVER_INI}" secret "$(head -c 20 /dev/urandom | sha1sum)"

    echo -e "
In der Datei:

* ${SYNC_SERVER_INI}

wird das Setup vorgenommen.
${Yellow}
[server:main]
...
host = ${GUNICORN_HOST}
port = ${GUNICORN_PORT}
...
[syncserver]
public_url = ${PUBLIC_URL_IN_FFOX}

# für gunicorn muss die die public_url wie folgt geändert werden
#
# public_url = ${GUNICORN_PUBLIC_URL_IN_FFOX}

secret = $_secret
...
sqluri = ${SYNC_SERVER_DB}
${_color_Off}

Überprüfen Sie die Konfiguration, bevor Sie mit der Installation weiter
fortfahren."
    waitKEY
}

# ----------------------------------------------------------------------------
updateSyncServer(){
# ----------------------------------------------------------------------------

    local gitFolder="syncserver"

    rstHeading "Update Firefox SyncServer"
    userMozCloudOrExit
    echo

    # FIXME git config --global user.email "you@example.com"
    # FIXME git config --global user.name "Your Name"

    rstBlock "Es wird ein Update des Firefox Sync-1.5 Server durchgeführt"

    pushd "${MOZCLOUD_USER_HOME_FOLDER}/SYNC_SERVER_FOLDER}" > /dev/null
    git stash       # to save any local changes to the config file
    git pull        # to fetch latest updates from github
    git stash pop   # to re-apply any local changes to the config file
    make build      # to pull in any updated dependencies
}

# ----------------------------------------------------------------------------
runSyncServer(){
# ----------------------------------------------------------------------------

    local gitFolder="syncserver"

    rstHeading "Start gunicorn Sync-1.5 Server (port: ${GUNICORN_PORT})" section
    userMozCloudOrExit

    rstBlock "Für gunicorn muss die die public_url in der Datei
${SYNC_SERVER_INI} wie folgt geändert werden::

    public_url = ${GUNICORN_PUBLIC_URL_IN_FFOX}/"
    waitKEY

    rstBlock "Es wird der Firefox Sync-1.5 Server gestartet.  Diese Art den
Server zu starten ist für Testzwecke gedacht, der WEB-Sever ist gunicorn. Über
die folgende URL:

* ${GUNICORN_PUBLIC_URL_IN_FFOX}/token/1.0/sync/1.5

müsste nun eine JSON Ausgabe::

   {'status': 'error', 'errors': [{'location': 'body', 'name': '', 'description': 'Unauthorized'}]}

im WEB-Browser angezeigt werden."


    TEE_stderr 2 <<EOF | bash
cd ${MOZCLOUD_USER_HOME_FOLDER}/${gitFolder}
./local/bin/gunicorn \
  --paste ./syncserver.ini \
  --debug \
  --access-logfile ./access.log \
  --error-logfile ./error.log &>/dev/null &
SERVERS_PID=\$!
curl ${GUNICORN_PUBLIC_URL_IN_FFOX}/token/1.0/sync/1.5
kill \$SERVERS_PID
EOF
    waitKEY
}

# # ----------------------------------------------------------------------------
# installAuthServer(){
# # ----------------------------------------------------------------------------
#
#     local gitFolder="fxa-auth-server"
#
#     rstHeading "Accounts Authentication Server"
#
#     userMozCloudOrExit
#
#     rstHeading "clone / update " section
#     echo
#     _gitPull "https://github.com/mozilla/fxa-auth-server.git" "$gitFolder"
#     waitKEY 20
#
#     pushd "${MOZCLOUD_USER_HOME_FOLDER}/${gitFolder}" > /dev/null
#
#     rstHeading "install" section
#     npm install
#     waitKEY
#
#     rstHeading "test" section
#     npm test
#     waitKEY
#
#     popd > /dev/null
# }


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
