#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install LDAP-Client
# ----------------------------------------------------------------------------

# TODO: Option zum Löschen des test_account und der test_group

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

test_account=test_user
test_group=test_group

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

NSLCD_GID=nslcd

LDAP_CLIENT_PACKAGES="\
  ldap-utils \
"

LPADAUTH_CLIENT_PACKAGES="\
  ldap-auth-config ldap-auth-client \
"
#   rpcbind \

NSS_LDAP_PACKAGES="\
 libnss-ldapd nslcd nscd glibc-doc-reference
"

LIBPAM_LDAPD_PACKAGES="\
  libpam-ldapd libpam-doc \
"

# ----------------------------------------------------------------------------
README() {
    rstHeading "NSS, PAM & LDAP-Client"
# ----------------------------------------------------------------------------

    echo -e "
Für eine Authentifizierung über LDAP sind neben der LDAP-Infrastruktur
Anpassungen an NSS und PAM erforderlich. Debian verwendet für NSS-LDAP und
PAM-LDAP die Implementierungen aus dem 'nss-pam-ldapd' Projekt.  Die
Installation ist in folgende Schritte unterteil:

* Setup LDAP-Client/Server Verbindung

  - Pakete: ${LDAP_CLIENT_PACKAGES}
  - SSL Kommunikation
  - /etc/ldap/ldap.conf

* Setup Auth-Client (LDAP)

  - Pakete: ${LPADAUTH_CLIENT_PACKAGES}
  - /etc/ldap.conf

* Setup NSS (libnss-ldapd, aka nss-pam-ldapd)

  - Pakete: ${NSS_LDAP_PACKAGES}
  - /etc/nsswitch.conf   GNU Name Service Switch functionality
  - /etc/default/nss     Name Service Switch in the GNU C library
  - /etc/nslcd.conf      Konfiguration für die Lookups auf dem LDAP Server
  - /etc/default/nslcd   Die Default Einstellungen des init-Skripts für den Daemon
  - /etc/nscd.conf       Das Setup für den NSS-Cache des nscd

* Setup PAM (libpam-ldapd aka nss-pam-ldapd)

  - Pakete: ${LIBPAM_LDAPD_PACKAGES}

Die Trennung der Installationsschritte erfolgt thematisch. Aus Sicht der
Paketierung ist sie etwas willkürlich, da sich die Pakete z.T. bereits
gegenseitig als Abhängigkeiten installieren.

* ldap-auth-config benötigt
  --> ldap-auth-client
      --> libnss-ldapd --> nslcd
      --> libpam-ldapd --> nslcd

* nscd (Caching Daemon)
  --> libc-bin

Das 'libc-bin' Paket ist ein Basispaket, es enthält die 'Standard C Library',
die bereits in jedem System vorinstalliert ist (ohne die geht gar nichts). Tools
wie 'getent' nutzen für die Name-Service-Lookups die Bibliotheken aus dem
'libc-bin' Paket.  Wenn 'nscd' installiert ist, dann bedient sich die 'Standard
C Library' des Caching Daemons ('nscd').

Der Caching Daemon ('nscd') führt seine LDAP-Lookups über den 'nslcd' Dienst
durch, der die Anfragen an den LDAP-Server absetzt. Die Installation eines Cache
erscheint auf den ersten Blick evtl. etwas übertrieben, es hat aber zwei
Vorteile: zum einen muss nicht jede Anfrage an den LDAP Server durchgereicht
werden (perfomance) zum anderen unterstützt es *offline* Szenarien, wie z.B. bei
mobielen Geräten (Laptops), die nicht immer *online* sein können.

Die Pakete 'libnss-ldapd' und 'libpam-ldapd' basieren zwar beide auf dem 'nslcd'
jedoch nehmen sie unterschiedliche Setups bei der Installation vor. Während
'libnss-ldapd' den NSS für LDAP konfiguriert, wird mit 'libpam-ldapd' das Setup
des PAM vorgenommen.

Neben den Paketnamen 'nslcd' und 'nscd' können auch die Paketnamen
'libpam-ldapd' und 'libpam-ldap' (ohne 'd' am Ende) verwechselt werden. Ferner
ist zwischen den zwei 'ldap.conf' Dateien zu unterscheiden:

* /etc/ldap.conf:      LDAP Setup für NSS und PAM
* /etc/ldap/ldap.conf: Setup für die LDAP Client Programme

LDAP:

* https://de.wikipedia.org/wiki/OpenLDAP
* https://www.digitalocean.com/community/tutorials/understanding-the-ldap-protocol-data-hierarchy-and-entry-components
* https://wiki.debian.org/LDAP/OpenLDAPSetup#Configuring_LDAPS

PAM & NSS:

* PAM: https://de.wikipedia.org/wiki/Pluggable_Authentication_Modules
* NSS: https://de.wikipedia.org/wiki/Name_Service_Switch
* nss-pam-ldapd: https://arthurdejong.org/nss-pam-ldapd/design
* nscd: https://wiki.debian.org/LDAP/NSS#Offline_caching_of_NSS_with_nscd
" | less
    showConfigHints
}

# ----------------------------------------------------------------------------
deinstall() {
    rstHeading "Deinstallation der LDAP-Client-Authentifizierung"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG: ${_color_Off}

    Folgende Aktion löscht die gesammte LDAP-Client und NSS Konfiguration."

    if askNy "Wollen sie WIRKLICH die Konfiguration löschen?"; then
        aptPurgePackages ${LPADAUTH_CLIENT_PACKAGES} ${NSS_LDAP_PACKAGES} ${LIBPAM_LDAPD_PACKAGES}
    fi
}

# ----------------------------------------------------------------------------
reconfigure() {
    rstHeading "Neukonfiguration der LDAP-Auth Pakete"
# ----------------------------------------------------------------------------

    showConfigHints
    rstBlock_stdin <<EOF
ACHTUNG:

  Folgende Aktion wird Ihre LDAP-Client Konfiguration neu aufsetzen.
EOF
    if askNy "Wollen sie WIRKLICH die Konfiguration löschen/neu aufsetzen?"; then

        # LDAP Auth Client
        dpkg-reconfigure -plow ldap-auth-config
        dpkg-reconfigure -plow libpam-runtime
        dpkg-reconfigure -plow libnss-ldapd
        dpkg-reconfigure -plow nslcd

    fi
}

# ----------------------------------------------------------------------------
showConfigHints() {
    rstHeading "LDAP-Server '${LDAP_SERVER}'" section
# ----------------------------------------------------------------------------

    echo -e "
DIT setup dc=$LDAP_AUTH_DC ${Yellow}

  * Search Base (DN)   --> ${LDAP_AUTH_BaseDN}
  * LDAP root account  --> cn=admin,${LDAP_AUTH_BaseDN}
  * LDAP URI (ssl)     --> ldaps://${LDAP_SERVER}:${LDAP_SSL_PORT}/
                           ldaps://$(getIPfromHostname ${LDAP_SERVER}):${LDAP_SSL_PORT}/

  * Organization       --> o=${ORGANIZATION}
  * LDAP Version       --> 3${_color_Off}
  * LDAP config admin  --> cn=admin,cn=config

Da der Hostname des LDAP Servers bei DNS Problemen u.U. nicht aufgelöst werden
kann empfiehlt es sich i.d.R. anstatt dem Hostnamen, die feste IP des
LDAP-Server zu verwenden."
}

# ----------------------------------------------------------------------------
probe_LDAP_server(){
    rstHeading "Test LDAP Server Request"
# ----------------------------------------------------------------------------

    rstBlock "Der LDAP-Server ${LDAP_SERVER}:${LDAP_SSL_PORT} muss erreichbar
sein ..."

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout "OUT: "
nc -zv ${LDAP_SERVER} ${LDAP_SSL_PORT}
EOF
    waitKEY

    rstBlock "Anonymes Lesen vom LDAP-Server ...
"
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -x objectclass=posixAccount dn uidNumber gidNumber userPassword -LLL
EOF

    rstBlock "In der obigen Ausgabe sollten bis auf das Element 'userPassword'
alle Werte (dn, uidNumber,...) angezeit werden. Das 'userPassword' sollte nur
der Benutzer selbst oder der Admin *sehen* können, ansonsten stimmt was mit der
Zugriffskontrolle auf dem LDAP-Sever nicht."
    waitKEY

    rstBlock "Anmeldung mit dem '${test_account}' -Account (bindDN:
uid=${test_account},ou=Users) am LDAP Server.  ${BYellow}Passwort für den
Benutzer '${test_account}': ${_color_Off}"

    TEE_stderr <<EOF | bash | prefix_stdout "OUT: "
ldapsearch -x -W -LLL \
 -D uid=${test_account},ou=Users,dc=${LDAP_AUTH_DC} \
 -b uid=${test_account},ou=Users,dc=${LDAP_AUTH_DC} \
 objectclass=posixAccount dn uidNumber gidNumber userPassword
EOF
    rstBlock "Wenn man sich als LDAP-User anmeldet kann man auch sein eigenes
'userPassword' *lesen*. Folglich müsste in der obigen Ausgabe das Feld mit dem
Hash-Value erscheinen."
    waitKEY

    rstBlock "Lesen als Admin (bindDN: cn=admin,cn=config) vom
LDAP-Server.  ${BYellow}Passwort für den LDAP-Admin des DIT: ${_color_Off}
"
    TEE_stderr <<EOF | bash | prefix_stdout "OUT: "
ldapsearch -x -W -LLL -s one -D "cn=admin,cn=config" dn ou cn objectClass
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
probe_LDAP_auth(){
    rstHeading "Test der LDAP basierenden Dienste"
# ----------------------------------------------------------------------------

    rstHeading "getent" section
    echo
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout "OUT: "
getent passwd ${test_account}
EOF
    waitKEY

    rstHeading "Lokales Login eines Users aus dem LDAP" section

    rstBlock "Sofern das PAM Modul 'mkhomedir' aktiviert wurde, müsste bei der
Anmeldung auch ein HOME Ordner angelegt werden (falls er nicht bereits
exisitert)."
    echo
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout "OUT: "
su -l ${test_account} -c "ls -la ~"
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
setup_ldap_client(){
    rstHeading "Setup LDAP-Client/Server Verbindung"
# ----------------------------------------------------------------------------

    local crt_file="/usr/share/ca-certificates/ldap-host-$(echo $LDAP_SERVER | sed 's/^\.//; s/\..*$//').crt"

    rstBlock "Konfiguriert die Defaults für LDAP-Clients des OpenLDAP. Die
Konfiguration wird in der Datei '/etc/ldap/ldap.conf' vorgenommen. Diese
Konfiguration ist Teil der OpenLDAP-Bibliotheken (Paket 'libldap').

In dieser Konfiguration wird auch eingestellt, dass der LDAP-Client mit dem
Server eine SSL Verbindung aufbaut.

Nachdem die LDAP-Client Einstellungen erfolgt sind, wird ein einfacher Test
durchgeführt, bei dem LDAP Lookups an den LDAP-Server gestellt werden.
Verlaufen diese Tests positiv, dann sind LDAP-Server und LDAP-Client korrekt
eingestellt und können kommunizieren.

Weiterführende Literatur:

* ldap.conf(5)
"
    waitKEY

    rstHeading "LDAPs (SSL) '${LDAP_SERVER}:${LDAP_SSL_PORT}'" section

    rstBlock "Damit die LDAP-Clients (ldap-utils, ldapsearch etc.) das
selbst-signierte Zertifikat des LDAP-Servers akzeptieren, muss das Zertifikat
auf den Client-Host kopiert und dort in *ca-certificates* eingetragen werden.
Diese Konfiguration ist für alle LDAP-Client-Hosts erforderlich und wird jetzt
für diesen Host vorgenommen."

    rstBlock "\
Es wird geprüft, ob für die Kommonikation auf '${LDAP_SERVER}:${LDAP_SSL_PORT}'
ein Zertifikat eingerichtete ist::
"

    # FIXME: hier muss man den LDAP_SERVER=storage angeben und man
    # sollte das Skript "./certs install" ausführen um das Zertifikat
    # vom storage zu installieren
    waitKEY
    TEE_stderr <<EOF | bash | prefix_stdout
openssl s_client -showcerts -servername ${LDAP_SERVER}\
  -connect ${LDAP_SERVER}:${LDAP_SSL_PORT} 2>/dev/null | \
  openssl x509 -inform pem -noout -text
EOF
    waitKEY

    # Symbolische Links im /usr/share/ca-certificates/ werden nicht ausgewertet,
    # weshalb (auch auf dem LDAP-Server) eine Kopie des Zertifikats angelegt
    # wird.

    rstBlock "Es wird versucht, das Zertifikat vom LDAP Server hier auf den
LDAP-Client zu kopieren::"

    waitKEY
    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
openssl s_client -showcerts \
    -connect ${LDAP_SERVER}:${LDAP_SSL_PORT} </dev/null 2>/dev/null \
    | openssl x509 -outform PEM >${crt_file}
EOF
    if [[ ! -e ${crt_file} ]]; then

        echo
        err_msg "Zertifikat konnte nicht kopiert werden!

Wenn der Server ein Zertifikat anbietet, sollte es (jetzt) in den folgenden
Ordner hier auf dem LDAP-Client kopiert werden.::${Yellow}

   /usr/share/ca-certificates

${Red}Erst danach kann mit der Installation fortgefahren werden.${_color_Off}
"
        waitKEY
    fi
    rstBlock "Aktivieren Sie in dem folgendem Dialog das Zertifikat:

  ${Yellow}$(basename ${crt_file})${_color_Off}
"
    waitKEY
    dpkg-reconfigure ca-certificates

    TITLE="LDAP Client Installation"\
         aptInstallPackages ${LDAP_CLIENT_PACKAGES}

    rstHeading "LDAP Client Konfiguration" section

    rstBlock "Das 'libldap' Paket wurde i.A. bereits als Abhängigkeit installiert.
Zu dem Paket gehört auch die Clientseitige Konfiguration in der Datei::

   /etc/ldap/ldap.conf

Um mit den ldap-utils arbeiten zu können, muss diese *minimale* Konfiguration
nun eingerichtet werden. Wobei folgend der Aufbau der Kommunikation zw. Client
und Server im Focus liegt (Zertifiziert oder eben *nicht* Zertifiziert).::
"

    echo -en "${Yellow}
  BASE  $LDAP_AUTH_BaseDN
  URI   ldaps://$(getIPfromHostname ${LDAP_SERVER})/

  # TLS_CACERT:
  #   Datei mit den CA's. Meint: Datei mit den anerkannten (selbst-signierten)
  #   Zertifizierungen und Zertifizierungsstellen.

  TLS_CACERT /etc/ssl/certs/ca-certificates.crt

  # TLS_REQCERT:
  #   * never:  Client prüft niemals Server Zertifikate.
  #   * allow:  Client prüft Zertifikat nur, wenn es vom Server angeboten wird.
  #   * try:    Ist im Grunde das gleiche wie 'allow'.
  #   * demand: Client prüft immer auf ein vorhandenes und gültiges Zertifikat.
  #   * hard:   Ist im Grunde das gleiche wie 'demand'.
  #
  # Am meisten Sinn macht 'allow', wenn der LDAP Server kein Zertifikat anbietet.
  # Wenn der Server ein Zertifikat anbietet, sollte es entweder auf dem Client
  # instaliert werden oder aber über eine bekannte CA verfiziert werden können.
  # Für Zertifikate ist von daher nur der Wert 'demand' wirklich sinnvoll.  In
  # weniger kritischen Umgebungen kann 'allow' die Zertifizierung einsparen.

  TLS_REQCERT  demand
${_color_Off}"

    waitKEY
    TEMPLATES_InstallOrMerge /etc/ldap/ldap.conf root root 644
    waitKEY

    rstHeading "Test LDAP-Client anonymous (ldaps://)" section

    rstBlock "Für die Benutzerverwaltung im LDAP ist ein anonymer (lesender)
Zugriff auf den DIT des LDAP-Servers erforderlich. Damit können NSS Tools
z.B. für die Benutzer und Gruppen IDs bei einem 'ls -la' die Namen aus dem LDAP
ermitteln. Folgend wird ein anonymer Zugriff getestet, der alle im LDAP
hinterlegten Benutzer-Logins (posixAccount) auflistet::
"
    waitKEY

    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -x objectclass=posixAccount dn uidNumber gidNumber -LLL
EOF

    rstBlock "Sollte obige Anfrage nicht erfolgreich sein, so sollte man prüfen
ob es Probleme mit dem Zertifikat gibt. Dazu führt man das Kommando am besten
mit dem Schalter '-d 1' aus und schaut sich die Debug-Ausgaben an.

Wenn das Zertifikat des Servers nicht validiert werden konnte, dann sollte in
etwa folgender Fehler in der Ausgaben erscheinen::${Yellow}

    TLS: peer cert untrusted or revoked (0x42)
    TLS: can't connect: (unknown error code).${_color_Off}
"
    if askNy "Soll die Anfrage im Debug Modus wiederholt werden?"; then
        TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -d 1 -x objectclass=posixAccount dn uidNumber gidNumber -LLL
EOF
        waitKEY
    fi

    rstBlock "Die Installation des LDAP-Client ist damit abgeschlossen. Darauf
aufbauend kann das Benutzermanagement des Client-Hosts so eingerichtet werden,
dass es sich der auf dem LDAP-Server hinterlegten Benutzer und Gruppen bedient.
"
    waitKEY
}
# ----------------------------------------------------------------------------
setup_ldap_auth_client(){
    rstHeading "Setup Auth-Client (LDAP)"
# ----------------------------------------------------------------------------

    echo -e "
Installiert (u.A.) das Paket 'ldap-auth-config', das wiederum PAM-LDAP NSS-LDAP
installiert. Im Zentrum der Auth-Client LDAP Konfiguration steht die Datei::

    /etc/ldap.conf

die von den folgenden Tools genutzt wird:

* LDAP Name Service Switch (NSS) und
* LDAP PAM Module.

Diese Tools werden aber in diesem Installationsschritt noch nicht vollständig
eingerichtet."
    waitKEY

    DEBIAN_FRONTEND=noninteractive \
         aptInstallPackages ${LPADAUTH_CLIENT_PACKAGES}

    rstHeading "/etc/ldap.conf" section
    echo -e "
In der /etc/ldap.conf sollte Folgendes konfiguriert werden:: ${Yellow}

# Reconnect policy: hard (default) / soft fail immediately.
bind_policy soft

# The distinguished name of the search base.
base dc=${LDAP_AUTH_DC}

# The distinguished name to bind to the server with if the effective user ID is
# root. Password is stored in /etc/ldap.secret (mode 600)
rootbinddn cn=admin,dc=${LDAP_AUTH_BaseDN}

# Another way to specify your LDAP server is to provide an
uri ldaps://$(getIPfromHostname ${LDAP_SERVER})/

pam_password md5
nss_initgroups_ignoreusers <die system-user> ...
${_color_Off}"

    TEMPLATES_InstallOrMerge /etc/ldap.conf root root 644
    waitKEY

    showConfigHints

    echo -e "
Um auf dem Client-Host die Tools zum Ändern des Passworts nutzen zu können, muss
für das zuvor eingerichtete 'rootbinddn'::

    ${Red}rootbinddn cn=admin,dc=${LDAP_AUTH_BaseDN}${_color_Off}

das Passwort des DIT-Admins auf dem Client-Host hinterlegt werden. Im folgenden
Dialog muss dazu die Frage 'Make local root Database admin?' mit 'Ja'
beantwortet werden, darauf hin gibt man das Passwort ein und dieses wird dann in
/etc/ldap.secret (nur für root lesbar) hinterlegt.
${Red}
    Im folgenden Setup sollten die Werte entsprechend
    obigen Angaben gesetzt werden ...
${_color_Off}"

    # FIXME: mir gefällt es nicht, dass Passwort für "cn=admin,dc=..."  auf
    # jedem Client hinterlegen zu müssen. Wenn da mal jemand die Platte ausbaut
    # oder mit einer LiveCD bootet, kann er das Passwort direkt auslesen. Gibt
    # es für das Problem nicht eine elegantere Lösung?

    waitKEY
    dpkg-reconfigure -plow ldap-auth-config

    rstBlock "Die Basis Installation des LDAP Auth-Client ist damit
abgeschlossen. Um die Authentifizierung aber nutzen zu können müssen in einem
weiteren Schritt noch NSS und PAM eingerichtet werden.
"
    waitKEY
}

# ----------------------------------------------------------------------------
setup_libnss_ldapd(){
    rstHeading "Setup NSS (libnss-ldapd, aka nss-pam-ldapd)"
# ----------------------------------------------------------------------------

    echo -e "
Installiert das Paket 'libnss-ldapd', welches das (alte) 'libnss-ldap' (ohne 'd'
am Ende) ersetzt. Die NSS-Lookups im LDAP Server werden über das Paket 'nslcd'
(das 'l' in der mitte steht für 'LDAP') realisiert. Zu dem NSS gibt es noch das
'nscd' Paket (nicht zu verwechseln mit 'nslcd') zum Cachen der Lookups aus dem
LDAP, das ebenfalls installiert wird.

Zu dem NSS, dem NSS-LDAP-Lookup und dem NSS-Cache gehören die folgenden
Config-Dateien:

Name Service Switch (NSS / nsswitch)

  /etc/nsswitch.conf   # GNU Name Service Switch functionality
  /etc/default/nss     # Name Service Switch in the GNU C library
  /etc/ldap.conf       # Wird auch vom PAM-LDAP Modul genutzt

LDAP Name Service Daemon (nslcd)

  /etc/nslcd.conf      # Konfiguration für die Lookups auf dem LDAP Server
  /etc/default/nslcd   # Die Default Einstellungen des init-Skripts für den Daemon

NSS-Cache Daemon

  /etc/nscd.conf       # Das Setup für den NSS-Cache ('nscd')

Weiterführende Literatur:

* http://arthurdejong.org/nss-pam-ldapd/setup
* https://wiki.debian.org/LDAP/NSS#NSS_Setup_with_libnss-ldapd
* https://wiki.debian.org/LDAP/NSS
* /usr/share/doc/nslcd/"
    waitKEY
    DEBIAN_FRONTEND=noninteractive \
         aptInstallPackages ${NSS_LDAP_PACKAGES}

    rstHeading "Setup NSS-Switch (nsswitch)" section

    echo -e "
In der Datei /etc/nsswitch.conf sollte Folgendes konfiguriert werden (man
nsswitch.conf).

${Red}Wichtig ist, dass der Wert ${BGreen}'ldap'${Red} immer am Ende der Zeilen stehen muss!
${Yellow}
  passwd:         compat ldap
  group:          compat ldap
  shadow:         compat ldap

  hosts:          files myhostname mdns4_minimal [NOTFOUND=return] dns ldap
  networks:       files ldap

  protocols:      db files ldap
  services:       db files ldap
  ethers:         db files ldap
  rpc:            db files ldap

  netgroup:       nis ldap
  aliases:        ldap${_color_Off}"

    TEMPLATES_InstallOrMerge /etc/nsswitch.conf root ${NSLCD_GID} 640
    waitKEY
    dpkg-reconfigure -plow libnss-ldapd

    rstHeading "Setup NSS Setup (Client Bibliothek)" section

    rstBlock "Tools wie 'getent' nutzen für den NSS die Bibliotheken aus dem
libc-bin Paket, das bereits eine Konfiguration in /etc/default/nss installiert
hat."
    TEMPLATES_InstallOrMerge /etc/default/nss root root 644 waitKEY

    rstHeading "LDAP Name Service Daemon (nslcd)" section
    echo -e "
In der Konfiguration /etc/nslcd.conf wird der 'nslcd' Dienst konfiguriert, siehe
nslcd.conf(8). In der Datei sollte Folgendes konfiguriert werden: ${Yellow}

  # The user and group nslcd should run as.
  uid nslcd
  gid nslcd

  # The search base that will be used for all queries.
  uri ldaps://$(getIPfromHostname ${LDAP_SERVER})/
  base dc=${LDAP_AUTH_DC}

  ldap_version 3
  tls_cacertfile  /etc/ssl/certs/ca-certificates.crt
  tls_reqcert     demand
${_color_Off}"
    TEMPLATES_InstallOrMerge /etc/nslcd.conf  root ${NSLCD_GID} 640
    waitKEY

    echo -e "
Das Setup für den NSS-Cache ('nscd')"
    TEMPLATES_InstallOrMerge /etc/nscd.conf  root root 644
    waitKEY

    echo -e "
Die Default Einstellungen des init-Skripts für den nslcd Daemon"
    TEMPLATES_InstallOrMerge /etc/default/nslcd root root  644
    waitKEY

    dpkg-reconfigure -plow nslcd

    rstHeading "Neustart der Dienste" section
    echo
    systemctl restart nslcd
    systemctl status nslcd
    echo

    waitKEY
}

# ----------------------------------------------------------------------------
setup_libpam_ldapd(){
    rstHeading "Setup PAM (libpam-ldapd aka nss-pam-ldapd)"
# ----------------------------------------------------------------------------

    echo -e "
Es wird das 'libpam-ldapd' Paket installiert, welches das alte 'libpam-ldap'
(ohne 'd' am Ende) ersetzt. Mit dem Paket wird das PAM-Modul zur
Authentifizierung via LDAP eingerichtet. Das PAM-Modul für LDAP stammt aus
'nss-pam-ldapd' (http://arthurdejong.org/nss-pam-ldapd).

Damit PAM über LDAP authentifizieren kann, muss im PAM Setup in den
'/etc/pam.d/common-*' Dateien das 'pam_ldap.so' Modul eingetragen werden:

* /etc/pam.d/common-auth
* /etc/pam.d/common-password
* /etc/pam.d/common-account
* /etc/pam.d/common-session
* /etc/pam.d/common-session-noninteractive

Die LDAP Anbindung des 'pam_ldap.so' ist in der Datei:

  /etc/ldap.conf

konfiguriert. Dies Konfiguration wird auch vom NSS genutzt und wurde bereits bei
dessen Installation eingerichtet.

Weiterführende Literatur:

* pam_ldap(8)
* pam-auth-update(8)
* https://wiki.debian.org/LDAP/PAM
* http://arthurdejong.org/nss-pam-ldapd/setup
"
    DEBIAN_FRONTEND=noninteractive \
         aptInstallPackages ${LIBPAM_LDAPD_PACKAGES}

    rstBlock "In dem Ordner '/usr/share/pam-configs' werden die Profiele der PAM
Module abgelegt, die mit siehe pam-auth-update(8) administriert werden können.
Zu dem 'libpam-ldapd' Paket gehört die Konfiguration:

  /usr/share/pam-configs/ldap

Mit dem Tool 'pam-auth-update' können Module ausgewählt werden, die dann in den
'/etc/pam.d/common-*' Dateien eingerichtet werden. Zuvor werden hier in der
Installation jetzt erst mal diese Profiele angepasst.
"
    waitKEY

    rstHeading "PAM ldap" section
    TEMPLATES_InstallOrMerge /usr/share/pam-configs/ldap      root root 644
    waitKEY

    rstHeading "PAM mkhomedir" section
    TEMPLATES_InstallOrMerge /usr/share/pam-configs/mkhomedir root root 644
    waitKEY

    rstHeading "pam-auth-update" section
    rstBlock "In den folgenden Dialogen muss nun 'LDAP Authentication (min. UID
10000)' aktiviert werden. Meist empfiehlt es sich auch gleich 'Create home
directory on login' zu aktivieren."
    waitKEY

    pam-auth-update
    waitKEY
}

# ----------------------------------------------------------------------------
main(){
    rstHeading "LDAP-Client Authentifizierung" part
# ----------------------------------------------------------------------------

    case $1 in

        info)
            setupInfo
            waitKEY
            showConfigHints
            ;;

        probe)
            probe_LDAP_server
            probe_LDAP_auth
            ;;

        install)
            README
            # LDAP-Client Config
            setup_ldap_client
            # LDAP-Auth Client
            setup_ldap_auth_client
            # NSS
            setup_libnss_ldapd
            # PAM LDAPD
            setup_libpam_ldapd
            # probe client config
            probe_LDAP_server
            probe_LDAP_auth
            ;;
        deinstall)
            deinstall
            ;;
        reconfigure)
            reconfigure
            ;;
        README)
            README
            ;;
        *)
            echo
            echo "usage $0 [README|info|install|probe|deinstall|reconfigure]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
