#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install OpenLDAP server
# ----------------------------------------------------------------------------

# FIXME:
# * https://wiki.debian.org/LDAP/OpenLDAPSetup#For_SAMBA_LDAP_support
# * https://wiki.debian.org/LDAP/OpenLDAPSetup#Configuring_LDAPS

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

test_account=test_user
test_group=test_group

LDAP_PACKAGES="\
 slapd ldap-utils \
"
LDAPSCRIPTS_PACKAGES="\
 ldapscripts pwgen
"
# ----------------------------------------------------------------------------
README_LDAP_OVERLAYS() {
    rstHeading "LDAP-Overlays"
# ----------------------------------------------------------------------------

    rstBlock "Für openLDAP gibt es Overlays:

*  http://www.openldap.org/doc/admin24/overlays.html

Es empfhielt sich, folgende Overlays zu installieren:

* memberOf: siehe templates/etc/ldap/memberof_overlay.ldif
* refint:   siehe templates/etc/ldap/refint_overlay.ldif
"
    waitKEY
}

# ----------------------------------------------------------------------------
README_POSIX_USERS() {
    rstHeading "LDAP- und System Benutzer (posix)"
# ----------------------------------------------------------------------------

    echo -en "
Es gibt Benutzer und Gruppen die dem System gehören z.B. die Gruppe mail
(Gruppen ID 8).

Die LDAP Benutzer werden mit den ldapscripts verwaltet.::

    # Anlegen eines Benutzers, zuerst muss die Gruppe angelegt werden, danach
    # wird der Benutzer angelegt, wobei er gleich fest seiner primären Gruppe
    # zugeordnet werden muss (daraus wird die gidNumber ermittelt)

    $ sudo -H ldapaddgroup myuser
    $ sudo -H ldapadduser myuser myuser

Um einen LDAP-User einer LDA-Gruppe hinzuzufügen verwendet man i.d.R. auch die
ldapscripts::

    $ sudo -H ldapaddusertogroup myuser othergroup

Um das Passwort eines Users im LDAP zu ändern verwendet man die ldapscripts::

    $ sudo -H ldapsetpasswd myuser

Der User selber ändert sein Passwort (wie gehabt) mit dem Kommando 'passwd' (das
zeigt einem auch, ob es sich um ein UNIX oder LDAP Passwort handelt)::

    $ passwd
    (current) LDAP Password:
    Geben Sie ein neues Passwort ein:
    Geben Sie das neue Passwort erneut ein:
    passwd: Passwort erfolgreich geändert

Die User-IDs sind in Bereiche aufgeteilt:

  * UID 0 - 999:         System-User wie 'root' oder 'www-data'

  * UID 1000 - 9.999:    Lokale Benutzer auf dem local-Host '$(hostname)'

  * UID 10.000 - xxxx:   Benutzer Logins, die im LDAP hinterlegt sind

Die lokalen Benutzer bzw. Gruppen (inkl. der System-Benutzer) werden mit den
Tools ``adduser(8)`` und ``addgroup(8)`` angelegt. Die Konfiguration der
ID-Bereiche dieser Benutzer bzw. Gruppen befindet sich in der Datei
``adduser.conf(5)`` (``FIRST_SYSTEM_UID``., ``FIRST_UID``). In der
/etc/adduser.conf sollte eingestellt sein::

  FIRST_SYSTEM_UID=100
  LAST_SYSTEM_UID=999
  ...
  FIRST_UID=1000
  LAST_UID=9999

In der /etc/ldapscripts/ldapscripts.conf sollte eingestellt sein::

  # Start with these IDs *if no entry found in LDAP*
  GIDSTART='10000' # Group ID
  UIDSTART='10000' # User ID       // s.a.: /etc/pam.d/common-* die Option "minimum_uid=10000"

Es kommt manchmal vor, dass ein LDAP-Benutzer einer System-Gruppe hinzugefügt
werden muss, z.B. muss der Benutzer zur Gruppe 'mail' (das ist eine
System-Gruppe ID 8) hinzugefügt werden, wenn er auf dem lokalen Host ein
Mailkonto haben soll. Da die System-Gruppe nicht im LDAP ist, kann man dafür
nicht die ldapscripts nutzen, sondern muss in diesen Fällen wieder auf das
usermod Kommando zurückgreifen::

   $ usermod -a -G mail myuser

Zur Benutzerverwaltung git es noch das debian Paket 'cpu'.

* http://manpages.ubuntu.com/manpages/utopic/man8/cpu-ldap.8.html

Der Paketname 'cpu' ist nicht nur sehr unglücklich gewählt, auch das ganze Paket
taugt nichts, da es nicht auf den ldapscripts aufbaut und schon seit 2004 nicht
mehr gepflegt wird. Hier ein Blick auf die Sourcen:

* https://bazaar.launchpad.net/~ubuntu-branches/ubuntu/vivid/cpu/vivid/files/head:/
"

    waitKEY
}

# ----------------------------------------------------------------------------
install() {
    rstHeading "LDAP (OpenLDAP) Server Installation" part
# ----------------------------------------------------------------------------

    TITLE="Installation der Basis-Pakete"\
         aptInstallPackages ${LDAP_PACKAGES}

    rstHeading "Root-DN für die Konfiguration" section

    rstBlock "Die Konfiguration des LDAP Servers liegt in dem DIT (cn=config).
Für das nun eine RootDN (cn=admin,cn=config) mit Password eingerichtet wird."

    LDAP_add_RootDN_ToConfig
    waitKEY

    rstHeading "LDAP Loglevel"
    if askNy "Soll das LogLevel gesetzt werden?"; then
        LDAP_setLoglevel
    else
        LDAP_unsetLoglevel
    fi
    waitKEY

    rstHeading "LDAPs (SSL)"

    rstBlock "Bei SSL stellt sich die Frage, ob überhaupt und wenn 'ja', wie
sich der Client über die Identität des Servers Klarheit verschaffen kann. Soll
eine Identitätsüberprüfung stattfinden, so muss der Server ein Zertifikat
anbieten. Das kann sein:

* Ein Zertifikat, das der Client über die Zertifizierungsstelle (**CA**)
  verifizieren kann.

* Ein **selbst-signiertes** Zertifikat, das einmalig auf jedem Client
  installiert werden muss.

Auf den meisten Linux Installationen mit SSL ist bereits ein *selbst-signiertes*
Zertifikat eingerichtet. Allgemein trägt es den Namen *snakeoil*. Wenn
vorhanden, so kann dieses auch für die Zertifizierung der LDAP (SSL)
Kommunikation genutzt werden."

    if [[ -e /etc/ssl/certs/ssl-cert-snakeoil.pem ]] ; then
        rstBlock "Es ist ein *snaikoil* Zertifikat auf diesem Host vorhanden."
        if askYn "Soll das Zertifikat auch für LDAPs eingerichtet werden"; then
            install_snakeoil_cert
            waitKEY
        fi
    else
        rstBlock "Es wurde KEIN *snaikoil* Zertifikat auf diesem Host gefunden."
    fi

    rstHeading "LDAP Client Konfiguration"

    rstBlock "Das libldap Paket wurde i.A. bereits als Abhängigkeit installiert.
Zu dem Paket gehört auch die Clientseitige Konfiguration in der Datei::

   /etc/ldap/ldap.conf

Um mit den ldap-utils arbeiten zu können, muss diese *minimale* Konfiguration
nun eingerichtet werden. Wobei folgend der Aufbau der Kommunikation zw. Client
und Server im Focus liegt (Zertifiziert oder eben *nicht* Zertifiziert).::"

    echo -en "${Yellow}
  BASE  $LDAP_AUTH_BaseDN
  URI   ldaps://${LDAP_SERVER}:${LDAP_SSL_PORT}/

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

    rstHeading "Neustart des LDAP Servers (slapd)" section
    echo
    systemctl restart slapd.service
    systemctl status slapd.service
    waitKEY

    rstHeading "Test LDAP-Client (ldaps://)" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldaps://${LDAP_SERVER}:${LDAP_SSL_PORT}/ -W -D "cn=admin,cn=config" -b cn=config -LLL "(olcDatabase=*)"
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
ldapsearch -d 1 -H ldaps://${LDAP_SERVER}:${LDAP_SSL_PORT}/ -W -D "cn=admin,cn=config" -b cn=config -LLL "(olcDatabase=*)"
EOF
        waitKEY
    fi

    rstBlock "Sofern bis hier hin kein Fehler auftritt, sind der LDAP Server und
die Kommunikation nun eingerichtet. Es kann mit dem Setup der Datenbanken (DITs)
begonnen werden."
    waitKEY

    rstHeading "LDAP Setup"

    rstBlock "Es existieren folgende RootDN Einträge:"
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" \
  "(olcRootDN=*)" olcSuffix olcRootDN olcRootPW -LLL -Q
EOF
    waitKEY

    rstHeading "Anlegen eines Directory-Information-Tree (DIT)"
    rstBlock "In einer default OpenLDAP Installation wird ein 'dc=nodomain' DIT
(die default Datenbank) angelegt. Diesen braucht man i.d.R. nicht.  Mittels
'dpkg-reconfigure -plow slapd' kann man das Setup komplett neu aufsetzen und
statt dem 'nodomain' DIT einen eigenen DIT anlegen, jedoch werden dabei alle
bestehenden DITs gelöscht.  Im Folgenden wird ein zusätzlicher DIT angelegt
(kein *dpkg-reconfigure*)."

    ask ORGANIZATION       "  Organization?            " "$ORGANIZATION"
    ask LDAP_AUTH_BaseDN   "  Distinguished Name (DN)? " "$LDAP_AUTH_BaseDN"
    ask LDAP_AUTH_DC       "  Domain Component (DC)?   " "$LDAP_AUTH_DC"
    echo
    askPassphrase "  password"
    LDAP_create_DIT "$LDAP_AUTH_BaseDN" "$LDAP_AUTH_DC" "$ORGANIZATION" "$passphrase"

    rstHeading "Setup Übersicht"
    showConfigHints
    waitKEY
}

# ----------------------------------------------------------------------------
install_snakeoil_cert() {
# ----------------------------------------------------------------------------

    if askNy "Soll das (snakeoil) Zertifikat vor der Installation angezeigt werden?"; then
        openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -text -noout | prefix_stdout
        waitKEY
    fi

    rstHeading "ldif für snakeoil" section
    LDAP_add_snakeoil_cert
    waitKEY

    rstHeading "LDAP-Server SSL aktivieren" section

    # Der User "openldap", unter dem der LDAP-Daemon läuft muss zur Gruppe der
    # ssl-cert hinzugefügt werden, ansonsten kann er nicht den privaten
    # Schlüssel aus dem /etc/ssl/private/ lesen. Der Fehler ist beim starten des
    # Daemon im syslog zu erkennen, die Zeile dazu ist:
    #
    #    """main: TLS init def ctx failed: -1"""
    #

    usermod -a -G ssl-cert ${OPENLDAP_USER}

    rstBlock "Um die Verschlüsselung zu aktivieren muss in der Konfiguration des
LDAP noch das Protokoll 'ldaps' gesetzt werden, siehe Datei:

     /etc/default/slapd

Empfohlener Eintrag mit dem von *aussen* über ssl port ${LDAP_SSL_PORT} (ldaps:///)
eine Verbindung aufgebaut werden kann.

     SLAPD_SERVICES=\"ldaps:/// ldapi:///\"

Die Interprozesskommunikation (IPC) 'ldapi:///' benötigt man i.d.R. ebenfalls,
sie wird auch während der Installation des Servers benötigt."

    TEMPLATES_InstallOrMerge /etc/default/slapd root root 644
    service slapd restart

    rstBlock "\
Es wird das, auf port '${LDAP_SERVER}:${LDAP_SSL_PORT}' eingerichtete
Zertifikat (client-Seitig) abgerufen/getestet ..."
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
openssl s_client -showcerts -servername ${LDAP_SERVER}\
  -connect ${LDAP_SERVER}:${LDAP_SSL_PORT} 2>/dev/null | \
  openssl x509 -inform pem -noout -text
EOF
}

# ----------------------------------------------------------------------------
deinstall() {
    rstHeading "Deinstallation des LDAP Severs"
# ----------------------------------------------------------------------------

    rstBlock "Folgende Aktion wird Ihre gesammte LDAP Konfiguration als auch
LDAP Datenbank inklusieve aller Nutzdaten löschen.

${Red}ACHTUNG:

  Die Nutzdaten in der Datenbank und bestehende Konfiguration gehen
  dabei ENDGÜLTIG VERLOREN!${_color_Off}"

    if askNy "Wollen sie WIRKLICH die Datenbank löschen?"; then
        aptPurgePackages ${LDAPSCRIPTS_PACKAGES} ${LDAP_PACKAGES}
        rm -f /etc/default/slapd
        rm -f /etc/ldapscripts/ldapscripts.conf
    fi
}

# ----------------------------------------------------------------------------
reconfigure() {
    rstHeading "Re-Konfiguration des LDAP Severs"
# ----------------------------------------------------------------------------

    rstBlock "Folgende Aktion wird Ihre gesammte LDAP Konfiguration als auch
LDAP Datenbank inklusieve aller Nutzdaten löschen.

${Red}ACHTUNG:

  Die Nutzdaten in der Datenbank und bestehende Konfiguration gehen
  dabei ENDGÜLTIG VERLOREN!${_color_Off}"

    if askNy "Wollen sie WIRKLICH die Datenbank und alle Einsttellungen löschen?"; then

        showConfigHints
        waitKEY
        dpkg-reconfigure -plow slapd

    fi
}

# ----------------------------------------------------------------------------
showConfigHints() {
# ----------------------------------------------------------------------------

   echo -e "
Die Konfigurationen in diesem Skript gehen davon aus, dass:${Yellow}

  * Als Backend eine MDB Datenbank verwendet wird.
  * Wenn der Hostname kein FQDN (keine Domain) besitzt, wird als
    DC nur der *einstellige* hostname verwendet.${_color_Off}

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
LDAP-Server zu verwenden.
"
}

# ----------------------------------------------------------------------------
showConfig() {
    rstHeading "Aktuelle Konfigurationen" part
# ----------------------------------------------------------------------------

    rstHeading "OpenLDAP (slapd)"
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
    slapd -VV
EOF
    waitKEY

    # https://www.digitalocean.com/community/tutorials/how-to-configure-openldap-and-perform-administrative-ldap-tasks
    rstHeading "LDAP Admin" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" "(olcRootDN=*)" olcSuffix olcRootDN olcRootPW -LLL -Q
EOF
    waitKEY

#     rstHeading "LDAP Build-In Schema" section
#     echo
#     TEE_stderr 1 <<EOF | bash | prefix_stdout
# ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=schema,cn=config" -s base -LLL -Q
# EOF
#     waitKEY

    rstHeading "LDAP Additional Schema" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=schema,cn=config" -s one -Q -LLL dn
EOF
    waitKEY

    rstHeading "LDAP Module" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" -LLL -Q "objectClass=olcModuleList"
EOF
    waitKEY

    rstHeading "LDAP Backends" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" -LLL -Q "objectClass=olcBackendConfig"
EOF
    waitKEY

    rstHeading "LDAP Datenbanken (DITs)" section
    echo
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" -LLL -Q "olcDatabase=*" dn "+"
EOF
    waitKEY

}

# ----------------------------------------------------------------------------
info_ldapscripts() {
    rstHeading "ldapscripts settings"
# ----------------------------------------------------------------------------

    echo
    if [[ ! -e /usr/share/ldapscripts/runtime ]]; then
        err_msg "ldapscripts not (yet) installed"
        return 42
    fi

    bash <<EOF | prefix_stdout
source /usr/share/ldapscripts/runtime
echo "LDAPBINOPTS: \$LDAPBINOPTS"
echo "LOGFILE:     \$LOGFILE"
echo "SASLAUTH:    \$SASLAUTH"
echo "SERVER:      \$SERVER"
echo "BINDDN:      \$BINDDN"
echo "BINDPWDFILE: \$BINDPWDFILE"

if [ -n "\$SASLAUTH" ]; then
  echo "  search:    \$LDAPSEARCHBIN \$LDAPBINOPTS \$LDAPSEARCHOPTS -Y \$SASLAUTH -H \$SERVER -s sub -LLL"
  echo "  add:       \$LDAPADDBIN    \$LDAPBINOPTS -Y \$SASLAUTH -H \$SERVER"
  echo "  modify:    \$LDAPMODIFYBIN \$LDAPBINOPTS -Y \$SASLAUTH -H \$SERVER"
  echo "  rename:    \$LDAPMODRDNBIN \$LDAPBINOPTS -Y \$SASLAUTH -H \$SERVER"
  echo "  password:  \$LDAPPASSWDBIN \$LDAPBINOPTS -Y \$SASLAUTH -H \$SERVER"
elif [ -n "\$BINDPWDFILE" ]; then
  echo "  search:    \$LDAPSEARCHBIN \$LDAPBINOPTS \$LDAPSEARCHOPTS -y \$BINDPWDFILE -D \$BINDDN -xH \$SERVER -s sub -LLL"
  echo "  add:       \$LDAPADDBIN    \$LDAPBINOPTS -y \$BINDPWDFILE -D \$BINDDN -xH \$SERVER"
  echo "  modify     \$LDAPMODIFYBIN \$LDAPBINOPTS -y \$BINDPWDFILE -D \$BINDDN -xH \$SERVER"
  echo "  rename     \$LDAPMODRDNBIN \$LDAPBINOPTS -y \$BINDPWDFILE -D \$BINDDN -xH \$SERVER"
  echo "  password:  \$LDAPPASSWDBIN \$LDAPBINOPTS -y \$BINDPWDFILE -D \$BINDDN -xH \$SERVER"
else
  echo "  search:    \$LDAPSEARCHBIN \$LDAPBINOPTS \$LDAPSEARCHOPTS -w \$BINDPWD -D \$BINDDN -xH $SERVER -s sub -LLL"
  echo "  add:       \$LDAPADDBIN    \$LDAPBINOPTS -w \$BINDPWD -D \$BINDDN -xH \$SERVER"
  echo "  modify:    \$LDAPMODIFYBIN \$LDAPBINOPTS -w \$BINDPWD -D \$BINDDN -xH \$SERVER"
  echo "  rename:    \$LDAPMODRDNBIN \$LDAPBINOPTS -w \$BINDPWD -D \$BINDDN -xH \$SERVER"
  echo "  password:  \$LDAPPASSWDBIN \$LDAPBINOPTS -w \$BINDPWD -D \$BINDDN -xH \$SERVER"
fi
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
LDAP_add_RootDN_ToConfig() {
# ----------------------------------------------------------------------------

    # siehe http://acidx.net/wordpress/2014/04/basic-openldap-installation-configuration/

    echo "Bitte geben Sie ein Passwort für RootDN (cn=admin,cn=config) ein ..."
    echo
    local ldif=$(cat <<EOF
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootDN
olcRootDN: cn=admin,cn=config

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $(slappasswd)
EOF
)

    echo -e "${Red}ldapmodify -Y EXTERNAL -H ldapi:///${_color_Off}"
    echo -e "$ldif" | prefix_stdout "<--|"
    echo -e "$ldif" | ldapmodify -Y EXTERNAL -H ldapi:///
}

# ----------------------------------------------------------------------------
LDAP_add_snakeoil_cert() {
# ----------------------------------------------------------------------------

    local ldif=$(cat <<EOF
dn: cn=config
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ssl/certs/ssl-cert-snakeoil.pem
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ssl/private/ssl-cert-snakeoil.key
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ssl/certs/ssl-cert-snakeoil.pem

EOF
)
    echo -e "${Red}ldapmodify -Y EXTERNAL -H ldapi:///${_color_Off}"
    echo -e "$ldif" | prefix_stdout "<--|"
    echo -e "$ldif" | ldapmodify -Y EXTERNAL -H ldapi:///
}

# ----------------------------------------------------------------------------
LDAP_setLoglevel() {
# ----------------------------------------------------------------------------

    local ldif=$(cat <<EOF
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: trace stats conns config ACL

EOF
)
    echo -e "${Red}ldapmodify -Y EXTERNAL -H ldapi:///${_color_Off}"
    echo -e "$ldif" | prefix_stdout "<--|"
    echo -e "$ldif" | ldapmodify -Y EXTERNAL -H ldapi:///
}

# ----------------------------------------------------------------------------
LDAP_unsetLoglevel() {
# ----------------------------------------------------------------------------

    local ldif=$(cat <<EOF
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: none
EOF
)
    echo -e "${Red}ldapmodify -Y EXTERNAL -H ldapi:///${_color_Off}"
    echo -e "$ldif" | prefix_stdout "<--|"
    echo -e "$ldif" | ldapmodify -Y EXTERNAL -H ldapi:///
}

# ----------------------------------------------------------------------------
LDAP_add_UserAndGroup() {
# ----------------------------------------------------------------------------

    local ldif=$(cat <<EOF
dn: ou=Users,${LDAP_AUTH_BaseDN}
objectClass: organizationalUnit
objectClass: top
ou: Users

dn: ou=Groups,${LDAP_AUTH_BaseDN}
objectClass: organizationalUnit
objectClass: top
ou: Groups

dn: ou=Machines,${LDAP_AUTH_BaseDN}
objectClass: organizationalUnit
objectClass: top
ou: Machines
EOF
)
    echo -e "${Red}ldapmodify -Y EXTERNAL -H ldapi:///${_color_Off}"
    echo -e "$ldif" | prefix_stdout "<--|"
    echo -e "$ldif" | ldapadd -W -D "cn=admin,${LDAP_AUTH_BaseDN}" -H ldaps:///
}

# ----------------------------------------------------------------------------
install_ldapscripts(){
    rstHeading "Setup der ldapscripts" part
# ----------------------------------------------------------------------------

    rstBlock "Die 'ldapscripts' dienen der vereinfachten Verwaltung von
Benutzern und Gruppen im LDAP. Es sind einfache shell-Skripte die der Admin auf
der Kommandozeile ausführen kann. Einziger Nachteil (wie ich finde): Ein
fehlerhaftes Setup der ldapscripts ist schwer zu debuggen.

Man kann die ldapscripts so konfigurieren, dass sie sich gegen einen entfernten
LDAP-Server verbinden, in einfachen Installationen ist das aber nicht zu
empfehlen. Sollte man sich dennoch für einen *entferneten* LDAP-Server
entscheiden, so muss ggf. noch das Passwort in der Datei:

  /etc/ldapscripts/ldapscripts.passwd

auf dem Client hinterlegt werden. Dabei sollte man aber darauf achten, dass die
Datei mit dem Passwort nur für den root-User lesbar ist!

  Generell sind Klartext-Passwörter in Konfigurationsdateien ein Schwachpunkt
  und sollten vermieden werden!!!

Dieses Setup geht davon aus, dass die ldapscripts (nur) auf dem LDAP-Server
installiert und genutzt werden: es verwendet das 'ldapi:://' Interface und
authentifiziert via SASL ('EXTERNAL' Methode). Bei dieser Authentifizierung muss
kein Passwort in einer Konfigurationsdatei hinterlegt werden."
    waitKEY

    aptInstallPackages ${LDAPSCRIPTS_PACKAGES}

    rstBlock "Installation der Templates für die ldapscripts"

    TEMPLATES_InstallOrMerge /etc/ldapscripts/ldapadduser.template root root 644
    TEMPLATES_InstallOrMerge /etc/ldapscripts/ldapaddgroup.template root root 644
    TEMPLATES_InstallOrMerge /etc/ldapscripts/ldapaddmachine.template root root 644
    waitKEY

    rstHeading "ldapscripts config" section
    cat <<EOF

In der Konfiguration der *ldapscripts* unter::

  /etc/ldapscripts/ldapscripts.conf

muss eingestellt werden, unter welchem Knoten (Suffix) die ldapscripts die
Gruppen und Benutzer ermitteln sollen. Hier eine exemplarische Konfiguration::

  SUFFIX="${LDAP_AUTH_BaseDN}" # Global suffix
  GSUFFIX="ou=Groups"        # Groups ou     (just under \$SUFFIX)
  USUFFIX="ou=Users"         # Users ou      (just under \$SUFFIX)
  MSUFFIX="ou=Machines"      # Machines ou   (just under \$SUFFIX)
  ...
  # use SASL's EXTERNAL authentication mechanism
  SASLAUTH="EXTERNAL"
  ...
  # The following BIND* parameters are ignored if SASLAUTH is set
  BINDDN="cn=admin,${LDAP_AUTH_BaseDN}"
  ...
  # Start with these IDs *if no entry found in LDAP*
  GIDSTART="10000" # Group ID
  UIDSTART="10000" # User ID       // s.a.: /etc/pam.d/common-* die Option "minimum_uid=10000"
  MIDSTART="20000" # Machine ID
  ...
  # User passwords generation
  PASSWORDGEN="pwgen -1"

  # You can specify custom LDIF templates here
  UTEMPLATE="/etc/ldapscripts/ldapadduser.template"
  GTEMPLATE="/etc/ldapscripts/ldapaddgroup.template"
  MTEMPLATE="/etc/ldapscripts/ldapaddmachine.template"

EOF

    TEMPLATES_InstallOrMerge /etc/ldapscripts/ldapscripts.conf root root 644
    waitKEY
    info_ldapscripts

    rstHeading "ldapscripts Schema" section
    cat <<EOF

Die ldapscripts benötigen in dem DIT für die Benutzer- und Gruppenverwaltung die
top DNs:

* "ou=Users,${LDAP_AUTH_BaseDN}"
* "ou=Groups,${LDAP_AUTH_BaseDN}"
* "ou=Machines,${LDAP_AUTH_BaseDN}"

EOF

    LDAP_add_UserAndGroup
    waitKEY

    rstHeading "ldapscripts test" section

    rstBlock "Die LDAP-Scripts sind eingerichtet, es können nun die Gruppen und
Benutzer damit angelegt werden.::"

    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapaddgroup ${test_group}
ldapadduser ${test_account} ${test_group}
EOF
    waitKEY

    rstBlock "Sollten die *ldapscripts* mit einer Fehlermeldung enden, so
überprüfen Sie die Konfiguration der *ldapscripts* (s.o.)::

  /etc/ldapscripts/ldapscripts.conf

Nachdem die Gruppe und der Benutzer angelegt wurden, müssten sie in einer Suche
gefunden werden::
"

    TEE_stderr 1 <<EOF | bash | prefix_stdout
ldapsearch -x -LLL -v  -b "${LDAP_AUTH_BaseDN}" -H ldaps://${LDAP_SERVER}:${LDAP_SSL_PORT}/ uid=${test_account}
EOF
    waitKEY

    rstBlock "Um den Account für den '${test_account}' zu vervollständigen wird noch
ein Passwort vergeben werden."

    echo -e "${Red}ldapsetpasswd ${test_account}${_color_Off}"
    ldapsetpasswd ${test_account}

}

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
        install)
            install
            install_ldapscripts
            rstBlock "Der LDAP Server, eine Datenbank und die 'ldapscripts'
wurden eingerichtet. Um die Benutzerverwaltung auf einen Host zu nutzen, muss
noch die Client-Seite installiert werden, was man am besten mit dem Skript
'LDAP_client_auth.sh' macht (auch auf dem LDAP-Server muss/sollte die
Client-Seite installiert werden)."
            ;;
        deinstall)
            deinstall
            ;;
        ldapscripts)
            install_ldapscripts
            ;;
        info)
            showConfig
            info_ldapscripts
            setupInfo
            ;;
        reconfigure)
            reconfigure
            ;;
        README)
            README_POSIX_USERS
            README_LDAP_OVERLAYS
            ;;
        *)
            echo "usage $0 [README|[de]install|info|reconfigure|ldapscripts]"
            ;;
    esac
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
