#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     common Apache-Setup
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

# of-topic
# ========

SQLITE3_PACKAGES="sqlitebrowser sqlite3"

# Apache
# ======

SERVICE_PACKAGES="\
 apache2 apache2-doc apache2-utils \
 libapache2-mod-authnz-external libapache2-mod-authz-unixgroup pwauth \
 libapache2-modsecurity \
 openssl-blacklist \
"

# Sites
# -----

APACHE_DEFAULT_SITES=(
    "000-default.conf"
    "default-ssl.conf"
)

# Modules
# -------

DISABLE_MODS="\
 cgi cgid \
"

ENABLE_MODS="\
 alias authz_host ssl rewrite headers env security2 \
 auth_digest authn_core authnz_external \
"

# Manche Module bringen ihre Defaul-Config mit, diese sind im Allgemeinen gut,
# aber manche dieser Conf-Dateien will man nicht als default haben.
DISABLE_MODS_DEFAULT_CFG="\
 alias wsgi autoindex dir \
"

# Konfigurationen
# ---------------

# apache2-doc: Die Apache Doku wird über unser sysdoc freigegeben, die apache
#              Freigabe wird nicht benötigt.

DISABLE_CONF="\
 apache2-doc \
 serve-cgi-bin \
"

# ModSecurity
# ===========

MOD_SECURITY_PACKAGES="\
 libapache2-mod-security2 \
"
MOD_SECURITY_MOD="security2"
MOD_SECURITY_DISABLE_CONF="security2"
MOD_SECURITY_CONF="mod_security2"
MOD_SEC_CRS_PROFILES="\
  owap_crs_2.2.9_10_minimal.conf \
  owap_crs_2.2.9_50_additional.conf \
  owap_crs_2.2.9_90_SecRuleRemove.conf \
"

# In dem Ordner OWASP_CRS_GIT_FOLDER wird das git-Repository ausgechekt und er
# wird in dem Profil owap_crs_2.2.9_minimal.conf *included*
OWASP_CRS_GIT_FOLDER="/usr/share/owasp-modsecurity-crs"
OWASP_CRS_GIT_URL="https://github.com/SpiderLabs/owasp-modsecurity-crs.git"
OWASP_CRS_GIT_BRANCH="v2.2/master"
OWASP_CRS_SETUP="modsecurity_crs_10_setup.conf"

# WEB apps
# ========

# /var/www/chrome wird aus der static-content.conf referenziert
CHROME_TEMPLATE=/var/www/chrome

# EXPIMP_FOLDER muss ggf. auch im Template
# /etc/apache2/sites-available/exp-imp.conf angepasst werden.
EXPIMP_FOLDER="/share/EXPIMP"
EXPIMP_URL="https://$HOSTNAME/EXPIMP"

# WEBSHARE_FOLDER muss ggf. auch im Template
# /etc/apache2/sites-available/webShare.conf angepasst werden.
WEBSHARE_FOLDER="/share/WEBSHARE"
WEBSHARE_URL="davs://$HOSTNAME/WEBSHARE"

# HTML-Intro
# ==========

HTML_INTRO_SITE=html-intro
HTML_INTRO_TEMPLATE="/var/www/html"
HTML_INTRO_URL="https://$HOSTNAME"

# System Dokumentationen
# ======================

SYSDOC_SITE=sysdoc
SYSDOC_FOLDER=/usr/share/doc
SYSDOC_URL="https://$HOSTNAME/sysdoc"

# phpApps
# =======

PHP_PACKAGES="\
  php php-sqlite3 \
  libapache2-mod-php \
"
PHP_APPS_SITE=php-apps
PHP_APPS="${WWW_FOLDER}/phpApps"

PHP_TEST_SITE=hello_php
PHP_TEST_TEMPLATE="${PHP_APPS}/helloWorld"
PHP_TEST_URL="https://$HOSTNAME/hello.php"

PHP_EXPLOIT_SITE=exploit_php
PHP_EXPLOIT_TEMPLATE="${PHP_APPS}/exploit_php"
PHP_EXPLOIT_URL="https://127.0.0.1/exploit.php"

# pyApps
# ======

WSGI_APPS_SITE=py-apps
WSGI_APPS="${WWW_FOLDER}/pyApps"
WSGI_TEST_SITE=hello_py
WSGI_TEST_TEMPLATE="${WSGI_APPS}/helloWorld"
WSGI_TEST_URL="https://$HOSTNAME/hello.py"

WSGI_PACKAGES="\
 libapache2-mod-wsgi \
 python-imaging \
"
PYENV=pyenv
PYENV_PACKAGES="\
 docutils Jinja2 Pygments Sphinx Flask Werkzeug pylint pyratemp pyudev \
 psutil sqlalchemy babel simplejson \
"

# ----------------------------------------------------------------------------
main(){
    rstHeading "Apache Setup" part
# ----------------------------------------------------------------------------

    sudoOrExit
    case $1 in
        info)
            info
            ;;
	install)
            installApachePackages
            serverwide_cfg
            site_static-content
            site_html-intro
            mod_security2
            site_sysdoc
            site_expimp
            site_webshare
            [[ ! -z ${APACHE_ADD_SITES} ]] && installAddSites
            APACHE_reload
	    ;;
        update)
            updateWSGI
            ;;
	deinstall)
            echo
            service apache2 stop
            deinstallPHP
            deinstallWSGI
            a2dissite  webShare.conf exp-imp.conf static-content.conf
            a2dismod   dav_fs dav
            deinstallApachePackages
	    ;;
        installPHP)
            installPHP
            ;;
        deinstallPHP)
            deinstallPHP
            APACHE_reload
            ;;
        installWSGI)
            installWSGI
            ;;
        deinstallWSGI)
            deinstallWSGI
            APACHE_reload
            ;;
        installAddSites)
            installAddSites
            ;;
	*)
            echo
	    echo "usage $0 [(de)install|update|(de)installPHP|(de)installWSGI]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
info(){
# ----------------------------------------------------------------------------

    rstHeading "Syntax Test"
    echo
    apachectl -t | prefix_stdout
    waitKEY 30

    rstHeading "Version und Build"
    echo
    apachectl -V | prefix_stdout
    waitKEY 30

    rstHeading "Module"
    echo
    apachectl -l | prefix_stdout
    echo
    apachectl -M | prefix_stdout
    waitKEY 30

    rstHeading "Setting"
    echo
    apachectl -S | prefix_stdout
    waitKEY 30

}

# ----------------------------------------------------------------------------
installApachePackages(){
    rstHeading "Installation der Apache Pakete"
# ----------------------------------------------------------------------------

    rstPkgList ${SERVICE_PACKAGES}
    echo
    waitKEY
    apt-get install -y ${SERVICE_PACKAGES}

    if [[ ! -z ${DISABLE_MODS} ]]; then
        rstHeading "de-aktiviere Module" section
        echo -en "\nmodules::\n\n  ${DISABLE_MODS}\n\n" | fmt
        a2dismod -f ${DISABLE_MODS} | prefix_stdout
        waitKEY
    fi

    rstHeading "de-aktiviere default Konfigurationen" section
    if [[ ! -z ${DISABLE_CONF} ]]; then
        echo -en "\nconfig::\n\n  ${DISABLE_CONF}\n\n" | fmt
        a2disconf -f ${DISABLE_CONF} | prefix_stdout
        waitKEY
    fi

    if [[ ! -z ${DISABLE_MODS_DEFAULT_CFG} ]]; then
        rstHeading "de-aktiviere defaults der Module" section
        echo -en "\nmodules::\n\n  ${DISABLE_MODS_DEFAULT_CFG}\n\n" | fmt
        APACHE_disable_mod_conf ${DISABLE_MODS_DEFAULT_CFG}
        waitKEY
    fi

    if [[ ! -z ${ENABLE_MODS} ]]; then
        rstHeading "aktiviere Module" section
        echo -en "\nmodules::\n\n  ${ENABLE_MODS}\n\n" | fmt
        a2enmod ${ENABLE_MODS} | prefix_stdout
        waitKEY
    fi

    rstHeading "SQLite Werkzeuge" section
    rstPkgList ${SQLITE3_PACKAGES}
    if askYn "Sollen die SQLite Pakete installiert werden?"; then
        apt-get install -y ${SQLITE3_PACKAGES}
        waitKEY
    fi

}

# ----------------------------------------------------------------------------
deinstallApachePackages(){
    rstHeading "De-Installation der Apache Pakete"
# ----------------------------------------------------------------------------

    rstPkgList ${SERVICE_PACKAGES} ${MOD_SECURITY_PACKAGES}
    echo
    waitKEY
    apt-get purge -y ${SERVICE_PACKAGES} ${MOD_SECURITY_PACKAGES}
    apt-get autoremove -y
    apt-get clean
    waitKEY
}

# ----------------------------------------------------------------------------
serverwide_cfg(){
    rstHeading "Serverweite Konfigurationen"
# ----------------------------------------------------------------------------

    local SITE

    rstHeading "Apache (apachectl) Umgebung." section

    rstBlock "Umgebungsvariablen des Serverprozess, wie z.B. die Benutzer- und
Gruppenzugehörigkeit des Apache WEB-Server (Prozess) werden in der
${APACHE_SETUP}/envvars festgelegt."

    TEMPLATES_InstallOrMerge "${APACHE_SETUP}/envvars" root root 644
    waitKEY

    rstHeading "Apache Port Konfiguration." section

    rstBlock "In der Konfigration werden die Ports 80 und 443 konfiguriert auf
denen der Apache Server *lauschen* soll."

    TEMPLATES_InstallOrMerge "${APACHE_SETUP}/ports.conf" root www-data 644
    waitKEY

    rstHeading "Server-Wide Configuration" section

    rstBlock "In der Konfiguration werden die *Server-Wide Configurations*
eingestellt, dazu gehören beispielsweise 'ServerName', 'ServerAdmin' und
'DocumentRoot'."

    TEMPLATES_InstallOrMerge "${APACHE_SETUP}/apache2.conf" root root 644

    waitKEY

    rstHeading "Basis Einstellungen zur Sicherheit" section

    rstBlock "Basis Konfiguration zur *Absicherung* des WEB-Servers. Abhänging
vom *Anwendungs- und Gefahrenkontext* sind die Anforderungen und Maßnahmen ganz
individuell. Diese Konfiguration muss ggf. angepasst werden."

    APACHE_install_conf security.conf
    waitKEY

    rstHeading "SSL und Rewrite (http:/ nach https:/)" section

    rstBlock "Mit den folgenden beiden *Sites* wird der *VirtualHost* für Port
80 (http://) eingerichtet. In dem die Redirects nach https:// konfiguriert
sind. Auf Port 443 wird der *VirtualHost* für https:// eingerichtet, der alle
HTTP-Requests über SSL annimmt und verarbeitet. Der Port 80 dient nur als
Redirect zum SSL."

    waitKEY

    for SITE in ${APACHE_DEFAULT_SITES[@]}; do
        rstBlock "${Orange}Site Konfiguration: ${SITE}${_color_Off}"
        TEMPLATES_InstallOrMerge "${APACHE_SITES_AVAILABE}/${SITE}" root root 644
        a2ensite -q "${SITE}"
        waitKEY
    done

    rstHeading "Mod_Authnz_External Authentifizierung" section

    rstBlock "Mit diesem Modul kann die Benutzerauthentifizierung an ein
externes Tool wie pwauth(8) durchgereicht werden. Im Standard und in diesem
Setup wird pwauth(8) verwendt. Das Tool pwauth(8) verwendet zur Autorisierung
die Benutzer Logins und Passwörter des Systems (PAM)."

    APACHE_install_conf authnz_external
    waitKEY

    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    rstHeading "Test des SSL Schlüssels" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
     echo | openssl s_client -connect localhost:https | openssl-vulnkey -
EOF
    waitKEY

    rstHeading "Test der Konfigurationen" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
    curl --location --verbose --head --insecure http://localhost 2>&1
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
mod_security2(){
    rstHeading "WAF: ModSecurity"
# ----------------------------------------------------------------------------

    rstBlock "Installation des Debian Pakets"

    rstPkgList ${MOD_SECURITY_PACKAGES}
    echo
    waitKEY
    apt-get install -y ${MOD_SECURITY_PACKAGES}

    rstHeading "de-aktiviere *default* Konfiguration der Module" section
    echo -en "\nmodules::\n\n  ${MOD_SECURITY_DISABLE_CONF}\n\n" | fmt
    APACHE_disable_mod_conf ${MOD_SECURITY_DISABLE_CONF}
    waitKEY

    rstHeading "Ersatz für die *default* Konfiguration" section
    APACHE_install_conf ${MOD_SECURITY_CONF}
    waitKEY

    rstHeading "Installiere die Rules aus dem OWASP CRS Projekt" section
    echo
    SUDO_USER= CACHE=$(dirname ${OWASP_CRS_GIT_FOLDER}) \
         cloneGitRepository ${OWASP_CRS_GIT_URL}  $(basename ${OWASP_CRS_GIT_FOLDER})
    cd ${OWASP_CRS_GIT_FOLDER}
    git checkout ${OWASP_CRS_GIT_BRANCH}

    rstBlock "OWASP CRS Basis-Konfiguration:

* ${OWASP_CRS_GIT_FOLDER}/${OWASP_CRS_SETUP}"

    if [[ -f  "${OWASP_CRS_GIT_FOLDER}/${OWASP_CRS_SETUP}" ]]; then
        rstBlock "  --> wurde bereits angelegt"
    else
        rstBlock "  --> wird angelegt"
        cp "${OWASP_CRS_GIT_FOLDER}/${OWASP_CRS_SETUP}.example" \
           "${OWASP_CRS_GIT_FOLDER}/${OWASP_CRS_SETUP}.conf"
    fi
    waitKEY

    rstHeading "Installiere CRS Profile" section
    echo -en "\nconfs::\n\n  ${MOD_SEC_CRS_PROFILES}\n" | fmt
    APACHE_install_conf ${MOD_SEC_CRS_PROFILES}
    waitKEY

    rstBlock "Prüfen ob das Modul geladen wird, Es sollte folgend eine Zeile
ausgegeben werden in der in etwa 'security2_module (shared)' steht:"

    TEE_stderr <<EOF | bash | prefix_stdout
apachectl -M | grep --color security2
EOF
    waitKEY

    rstBlock "Der folgende Test führt einen Request aus, der einer XSS Attacke
ähnelt, bei der ein Script-Tag in ein Formular eingebettet wurde. Der Request
müsste auf dem Server-Log des ModSecurity ein 'Message: Access denied ...'
liefern:"

    TEE_stderr <<EOF | bash | prefix_stdout
tail -n 1 -f /var/log/apache2/modsec_audit.log &
TAIL_PID=\$!
curl -k "https://127.0.0.1/exploit.php?secret_file=%3Cscript%20xss%3E" 2>/dev/null
kill \$TAIL_PID
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
site_html-intro(){
    rstHeading "HTML Startseite"
# ----------------------------------------------------------------------------

    rstBlock "Die HTML-Startseite stellt Verweise auf die Anwendungen zur
Verfügung, die mit diesem Skript installiert werden. Die Installation erfolgt
nach 'DocumentRoot' (siehe apache.conf).  Die Startseite ist nur *exemplarisch*
und kann bei Bedarf auch wieder deaktiviert werden:

.. code-block::

  sudo a2dissite ${HTML_INTRO_SITE}"

    if askYn "Soll die HTML Startseite installiert werden?"; then

        TEMPLATES_installFolder ${HTML_INTRO_TEMPLATE} root www-data
        waitKEY
        APACHE_install_site ${HTML_INTRO_SITE}
        echo
        echo "Zur Startseite --> ${HTML_INTRO_URL}"
        waitKEY
    fi
}

# ----------------------------------------------------------------------------
site_sysdoc(){
    rstHeading "System-Dokumentation"
# ----------------------------------------------------------------------------

    rstBlock "Es wird die System-Dokumentation (sysdoc-Site) aus dem Ordner

* ${SYSDOC_FOLDER}

über den WEB-Server freigegeben.  Die sysdoc-Site sollte nur in einer
Entwickler-Umgebung installiert werden. ${BRed}Sie sollte in KEINEM Fall in
einer produktiven Umgebung installiert werden!${_color_Off}. Die sysdoc-Site
kann bei Bedarf auch wieder deaktiviert werden:

.. code-block::

  sudo a2dissite ${SYSDOC_SITE}"

    if askNy "Soll die System-Dokumentation im WEB freigegeben werden?"; then

        APACHE_install_site ${SYSDOC_SITE}
        echo
        echo "Zur System-Dokumentation --> ${SYSDOC_URL}"
        waitKEY
    fi
}


# ----------------------------------------------------------------------------
site_static-content(){
    rstHeading "Apache static-content"
# ----------------------------------------------------------------------------

    local SITE=static-content.conf
    local AUTOINDEX_CONF=autoindex.conf

    rstBlock "Die Site ${SITE} dient zur Bereitstellung statischen Contents, das
sind z.B. Icons (im chrome-Ordner) oder Javascript Bibliotheken, die von den
WEB-Seiten nachgeladen werden. Zu der Site gehört auch eine *Autoindex*
Installation/Konfiguration, die es ermöglicht in den freigegeben Ordnern via
WEB-Browser zu navigieren.  Die Installation wird empfohlen, da auch noch
weitere Setups die ${SITE} benötigen. Autoindex als auch ${SITE} können
abgeschaltet werden.

.. code-block::

  sudo a2dismod autoindex
  sudo a2dissite ${SITE}"

    if ! askYn "Soll die *Site* ${SITE} eingerichtet werden?"; then
        return 42
    fi

    rstHeading "Autoindex Konfiguration" section
    echo
    a2enmod autoindex | prefix_stdout
    APACHE_install_conf ${AUTOINDEX_CONF}

    rstHeading "static-site Konfiguration" section
    APACHE_install_site ${SITE}
    TEMPLATES_installFolder "${CHROME_TEMPLATE}" root www-data

    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    echo
    echo "Zum static-Content --> https://$HOSTNAME/chrome"

    waitKEY

}

# ----------------------------------------------------------------------------
site_expimp(){
    rstHeading "Export/Import Ordner einrichten"
# ----------------------------------------------------------------------------

    local SITE=exp-imp.conf

    rstBlock "Die Konfiguration legt den ${EXPIMP_FOLDER} Ordern an und stellt
ihn über $EXPIMP_URL ins Netz. Sinnvoller Weise sollte man eine solche
ExpImp-Konfiguration nicht ohne weiteres ins Internet stellen.

Man kann die Konfiguration später aber auch wieder zurück nehmen, indem man die
Site deaktiviert.

.. code-block::

  sudo a2dissite ${SITE}"

    if ! askNy "Soll ${EXPIMP_FOLDER} erstellt und via Apache exportiert werden?"; then
        return 42
    fi
    install -o ${WWW_USER} -g ${WWW_USER} -m 777 -d "${EXPIMP_FOLDER}"

    rstHeading "Export / Import Ordner" part-nc > "${EXPIMP_FOLDER}/README"
    rstBlock "ACHTUNG: Alle Dateien in diesem Ordner werden über Apache exportiert!"\
             >> "${EXPIMP_FOLDER}/README"
    APACHE_install_site ${SITE}

    echo
    echo "Zum ExpImp-Ordner --> $EXPIMP_URL"
    waitKEY
}

# ----------------------------------------------------------------------------
site_webshare() {
    rstHeading "WebDAV ${WEBSHARE_FOLDER}"
# ----------------------------------------------------------------------------

    local SITE=webShare.conf

    rstBlock "Diese Konfiguration sollte man nicht ohne weiteres (z.B. quota) im
Internet betreiben! Man kann die Konfiguration später aber auch wieder zurück
nehmen, indem man die Site deaktiviert.

.. code-block:: bash

  sudo a2dissite ${SITE}

  sudo a2dismod dav

  sudo a2dismod dav_fs"

    if ! askNy "Soll ${WEBSHARE_FOLDER} erstellt und via WebDAV exportiert werden?"; then
        return 42
    fi
    install -o ${WWW_USER} -g ${WWW_USER} -m 700 -d "${WEBSHARE_FOLDER}"

    rstHeading "webShare / webDAV Ordner" part-nc > "${WEBSHARE_FOLDER}/README"
    rstBlock "Die Dateien in diesem Ordner werden über Apache exportiert."\
             >> "${WEBSHARE_FOLDER}/README"

    a2enmod dav
    a2enmod dav_fs
    APACHE_install_site ${SITE}

    if askNy "Soll ein Test des WebDAV Servers erfolgen?"; then
        # Für den Client wird cadaver installiert (zum Testen)
        apt-get install -y cadaver
        cadaver https://localhost/WEBSHARE
    fi

    rstBlock "Die WebDAV Clients wie z.B. ein Datei-Explorer können den WebDAV
Ordner unter folgender URL einbinden (Anmeldung mit Benutzer-Login erforderlich).

* $WEBSHARE_URL"

    waitKEY
}


# ----------------------------------------------------------------------------
installPHP(){
    rstHeading "PHP Anwendungen (phpApps)"
# ----------------------------------------------------------------------------

    rstBlock "Die Konfiguration installiert die erforderlichen Pakete für PHP
und sqlite3. Es wird der Ordner ${PHP_APPS} angelegt und eine Aapche
Konfiguration für diesen Ordner eingerichtet. In dem Ordner können
PHP-Anwendungen installiert werden.  Das Setup des ${PHP_APPS} Ordners ist
exemplarisch und sollte nicht ohne weiteres ins Internet gestellt werden. Das
Setup kann deinstalliert werden:

.. code-block::

  sudo ${0} deinstallPHP"

    if ! askYn "Soll PHP für Apache installiert werden?"; then
        return 42
    fi

    mkdir -p "${PHP_APPS}"

    rstPkgList ${PHP_PACKAGES}
    echo
    waitKEY
    apt-get install -y ${PHP_PACKAGES}
    a2enmod php7
    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    APACHE_install_site ${PHP_APPS_SITE}

    installPHPTestApp
    waitKEY
}

# ----------------------------------------------------------------------------
deinstallPHP(){
    rstHeading "De-Installation PHP Anwendungen (phpApps)"
# ----------------------------------------------------------------------------

    echo
    a2dismod php7
    APACHE_dissable_site ${PHP_TEST_SITE} ${PHP_APPS_SITE}

    rstPkgList ${PHP_PACKAGES}
    waitKEY
    apt-get purge -y ${PHP_PACKAGES}
    apt-get autoremove -y
    apt-get clean

    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    if [[ -d ${PHP_APPS} ]]; then
        rstHeading "Löschen der phpApps WEB-Anwendungen" section

        rstBlock "${Yellow}Die Anwendungen in dem Ordner ${PHP_APPS}/ bleiben
erhalten, wenn sie nicht jetzt gelöscht werden.  Sie müssen ggf. manuell
gelöscht werden.${_color_Off}"

        echo
        ls -la ${PHP_APPS} | prefix_stdout
        if askNy "Sollen ALLE Anwendungen jetzt GELÖSCHT werden? (${BRed}ACHTUNG:${_color_Off} kein Backup)"; then
            rm -r ${PHP_APPS} |  prefix_stdout
        fi
        waitKEY
    fi
}

# ----------------------------------------------------------------------------
installPHPTestApp(){
    rstHeading "PHP-Test Anwendung"
# ----------------------------------------------------------------------------

    rstBlock "Die Test-Site sollte nur in einer Entwickler-Umgebung installiert
werden. ${BRed}Sie sollte in KEINEM Fall in einer produktiven Umgebung installiert
werden!${_color_Off}

Zur DEINSTALLATION folgendes verwenden:

.. code-block::

  sudo a2dissite ${PHP_TEST_SITE}
  sudo rm -rf ${PHP_TEST_TEMPLATE}
"

    if askNy "Soll die php-Test Site installiert werden?"; then

        TEMPLATES_installFolder ${PHP_TEST_TEMPLATE} root www-data
        waitKEY
        APACHE_install_site ${PHP_TEST_SITE}
        echo
        echo "Zur PHP-Test Seite --> ${PHP_TEST_URL}"
    fi
}

# ----------------------------------------------------------------------------
installWSGI(){
    rstHeading "WSGI/Python Anwendungen (pyApps)"
# ----------------------------------------------------------------------------

    rstBlock "Die Konfiguration installiert die erforderlichen Pakete für
Python/WSGI. Es wird der Ordner ${WSGI_APPS} angelegt und eine Aapche
Konfiguration für diesen Ordner eingerichtet. In dem Ordner können
WSGI-/Python-Anwendungen installiert werden.

Zu dem Ordner wird eine *virtuelle* Python Umgebung (${PYENV}) eingerichtet, in
der die Python-Anwendungen laufen, wenn sie im WEB-Server betrieben werden. In
dieser Umgebung werden eine Reihe von Python Modulen vorinstalliert.

Das Setup des ${WSGI_APPS} Ordners ist exemplarisch und sollte nicht ohne
weiteres ins Internet gestellt werden. Das Setup kann deinstalliert werden:

.. code-block::

  sudo ${0} deinstallWSGI"

    if ! askYn "Soll WSGI für Apache installiert werden?"; then
        return 42
    fi

    # ----------------------------------------------------------------------------
    rstHeading "Basis WSGI Ausstattung"
    # ----------------------------------------------------------------------------

    mkdir -p "${WSGI_APPS}"

    rstPkgList ${WSGI_PACKAGES}
    echo
    apt-get install -y ${WSGI_PACKAGES}

    APACHE_disable_mod_conf wsgi
    a2enmod wsgi
    APACHE_install_site ${WSGI_APPS_SITE}
    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    # ----------------------------------------------------------------------------
    rstHeading "pyenv (${WWW_FOLDER}/pyApps)"
    # ----------------------------------------------------------------------------

    rstBlock "Es wird eine *virtuelle* Python Umgebung(${PYENV}) eingerichtet, in der die
WEB-Anwendungen betrieben werden können.:

* ${WSGI_APPS}/${PYENV}"

    pushd "${WSGI_APPS}" > /dev/null
    if [[ ! -x "${PYENV}" ]] ; then
        virtualenv "${PYENV}" --prompt="${PYENV}"
    else
        rstBlock "Virtuelle Python Umgebung (${WSGI_APPS}/${PYENV}) ist bereits eingerichtet"
    fi
    waitKEY

    # ----------------------------------------------------------------------------
    pushd "${PYENV}" > /dev/null
    source bin/activate
    # ----------------------------------------------------------------------------

    if [[ ! -x /etc/bash_completion.d/pip ]] ; then
        rstBlock "Richte shell completion für pip ein."
        pip completion --bash | sudo tee /etc/bash_completion.d/pip > /dev/null
    fi

    rstBlock "Es werden die gängigen pip-Pakete installiert, mit denen
Beispielsweise Flask WEB Anwendungen mit Datenbanken betrieben werden können."

    rstPkgList ${PYENV_PACKAGES}
    echo
    waitKEY
    # http://stackoverflow.com/a/34931432
    # pip install PIL --allow-external PIL --allow-unverified PIL
    pip install ${PYENV_PACKAGES}

    if askNy "sollen die PIP-Pakete aktualisiert werden?"; then
        pip install --upgrade ${PYENV_PACKAGES}
    fi

    rstBlock "Für Tests oder zur Installation weiterer Python Module kann die
virtuelle Python Umgebung auch in der Kommandozeile aktiviert werden::

  $ source ${WSGI_APPS}/${PYENV}/bin/activate"


    popd > /dev/null
    popd > /dev/null
    installWSGITestApp
    waitKEY
}

# ----------------------------------------------------------------------------
installWSGITestApp(){
    rstHeading "WSGI-Test Anwendung"
# ----------------------------------------------------------------------------

    rstBlock "Die Test-Site sollte nur in einer Entwickler-Umgebung installiert
werden. ${BRed}Sie sollte in KEINEM Fall in einer produktiven Umgebung installiert
werden!${_color_Off}"

    if askNy "Soll die WSGI-Test Site installiert werden?"; then

        TEMPLATES_installFolder ${WSGI_TEST_TEMPLATE} root www-data
        waitKEY
        APACHE_install_site ${WSGI_TEST_SITE}
        echo
        echo "Zur WSGI (python) Test-Seite --> ${WSGI_TEST_URL}"
    fi
}

# ----------------------------------------------------------------------------
updateWSGI() {
    rstHeading "Update Apache WSGI (python)"
# ----------------------------------------------------------------------------

    if [[ ! -x "${WSGI_APPS}" ]]; then
        rstBlock "WSGI not installed / nothing to update"
        waitKEY
        return 0
    fi
    pushd "${WSGI_APPS}" > /dev/null

    if [[ ! -x "${PYENV}" ]] ; then
        rstBlock "${PYENV} not installed / nothing to update"
    else
        pushd ${PYENV} > /dev/null
        source bin/activate
        if askYn "sollen die PIP-Pakete aktualisiert werden?"; then
            pip install --upgrade ${PYENV_PACKAGES}
            rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
            service apache2 restart
        fi
        popd > /dev/null
    fi
    popd > /dev/null
    waitKEY
}


# ----------------------------------------------------------------------------
deinstallWSGI(){
    rstHeading "De-Installation Apache WSGI (python)"
# ----------------------------------------------------------------------------

    rstPkgList ${WSGI_PACKAGES}
    echo
    waitKEY
    a2dismod wsgi
    APACHE_dissable_site "${WSGI_APPS_SITE}"

    apt-get purge -y ${WSGI_PACKAGES}
    apt-get autoremove -y
    apt-get clean

    rstBlock "${BGreen}Apache muss neu gestartet werden...${_color_Off}"
    service apache2 restart

    if [[ -d "${WSGI_APPS}/${PYENV}" ]]; then
        rstHeading "Löschen der ${PYENV} Umgebung"

        rstBlock "Die virtuelle Python Umgebung ${BYellow}${WSGI_APPS}/${PYENV}${_color_Off}
bleibt erhalten, sie muss ggf. manuell gelöscht werden."

        if askNy "Soll die virtuelle Python Umgebung gelöscht werden?"; then
            rm -r "${WSGI_APPS}/${PYENV}"
        fi
    fi

    if [[ -d "${WSGI_APPS}" ]]; then

        rstHeading "Löschen der pyApps WEB-Anwendungen"
        rstBlock "Die WSGI Anwendungen unter ${Yellow}${WSGI_APPS}/${_color_Off}
bleiben erhalten, sie müssen ggf. manuell gelöscht werden."
        echo
        ls -la ${WSGI_APPS} | prefix_stdout
        if askNy "Sollen die Anwendungen jetzt GELÖSCHT werden? (${BRed}ACHTUNG:${_color_Off} keine Sicherheitskopie)"; then
            rm -r ${WSGI_APPS}
        fi
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
installAddSites(){
    rstHeading "Installation zusätzlicher Sites"
# ----------------------------------------------------------------------------

    if [[ -z ${APACHE_ADD_SITES} ]]; then
        rstBlock "keine zusätzlichen Sites definiert"
        return 0
    fi

    echo -en "\nsites::\n\n  ${APACHE_ADD_SITES}\n\n" | fmt
    if askYn "Soll die Sites installiert werden?"; then
        APACHE_install_site ${APACHE_ADD_SITES}
        waitKEY
    fi
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
