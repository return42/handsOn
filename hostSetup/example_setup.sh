#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-

# =====================
# org stuff
# =====================

# ORGANIZATION="darmarIT"

# =====================
# Debian's Apache Setup
# =====================

# APACHE_SETUP="/etc/apache2"
# APACHE_SITES_AVAILABE="${APACHE_SETUP}/sites-available"
# APACHE_MODS_AVAILABE="${APACHE_SETUP}/mods-available"
# APACHE_CONF_AVAILABE="${APACHE_SETUP}/conf-available"

# APACHE_ADD_SITES="\
#   fxSyncServer\
#   OnlineDoc\
# "

# Debian's OpenLDAP Setup
# =======================

# LDAP_SERVER="myserver"
# LDAP_SSL_PORT=636
# OPENLDAP_USER=openldap
# SLAPD_DBDIR=/var/lib/ldap
# SLAPD_CONF="/etc/ldap/slapd.d"

# =======
# Firefox
# =======

# FFOX_GLOBAL_EXTENSIONS=/usr/lib/firefox-addons/extensions

# =====
# GNOME
# =====

# GNOME_APPL_FOLDER=/usr/share/applications

# ==============================================================================
# Backup der Konfigurationen
# ==============================================================================
#
# .. hint::
#
#    Dateien werden in der Sicherung für *alle* lesbar gesichert. Will man
#    Schlüssel oder Passwörter sichern, muss man die mit einer Passphrase
#    verschlüsseln. Die Dateien bzw. Ordner die verschlüsselt werden sollen,
#    müssen in der:
#
#    * CONFIG_BACKUP_ENCRYPTED definiert werden.
#
#    Die unverschlüsselten Sicherungen werden in der
#
#    * CONFIG_BACKUP definiert.
#
#    Ob eine Datei oder ein Ordner in die Sicherung & Versionierung soll ist
#    eine Entscheidung, die man selber treffen muss. Die handsOn Scripte spielen
#    Vorlagen aus dem TEMPLATE Ordner, es sein denn, sie finden im Backup eine
#    Datei (bzw. einen Ordner) am selben Pfad, dann verwenden die handsOn
#    Skripte diese Datei als *Template*.
#
#    Dateien der Konfiguration die ohnehin in ungeänderter Form im TEMPLATE -
#    Ordner vorliegen sollten deshalb besser nicht gesichert werden, zumindest
#    nicht solange, wie sie mit dem Original aus dem TEMPLATE Ordner identisch
#    sind. So bekommt man für die ungeänderten Dateien noch die Updates aus dem
#    TEMPLATE mit, wenn man eine Anwendung neu installiert oder *updatet*.
#
#    Eine grobe Empfehlung könnte sein:
#
#        *Sichere nur das, was Du auf DEM Host an Einstellungen geändert hast*
#

CONFIG_BACKUP_ENCRYPTED=(

    "/etc/ssl/private"
    "/etc/ldapscripts/ldapscripts.passwd"
    "/etc/ldap.secret"

    # SSH private
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_dsa_key"
    "/etc/ssh/ssh_host_ecdsa_key"
    "/etc/ssh/ssh_host_ed25519_key"

    # GitLab
    "/etc/gitlab/gitlab.rb"
    "/etc/gitlab/gitlab-secrets.json"

    # boinc
    "/etc/boinc-client/gui_rpc_auth.cfg"
)

# ==============================================================================
# Backup von Konfigurationsdateien
# ==============================================================================

CONFIG_BACKUP=(

    # LDAP-Client
    "/etc/ldap.conf"
    "/etc/ldap/ldap.conf"

    # OpenLDAP & ldapscripts
    "/etc/ldap"
    "/etc/default/slapd"
    "/etc/ldapscripts/ldapscripts.conf"

    # PAM
    "/etc/pam.d/common-auth"
    "/etc/pam.d/common-account"
    "/etc/pam.d/common-password"
    "/etc/pam.d/common-session"
    "/etc/pam.d/common-session-noninteractive"

    # LDAP, PAM & Name Service Switch (NSS)
    "/etc/nsswitch.conf"
    "/etc/nslcd.conf"
    "/etc/nscd.conf"
    "/etc/pam.conf"
    "/etc/pam.d"

    # Benutzerverwaltung
    "/etc/adduser.conf"
    "/etc/deluser.conf"
    "/etc/skel"

    # Verschiedenes aus dem System
    "/etc/fstab"
    "/etc/rsyslog.conf"
    "/etc/modules"
    "/etc/rc.local"

    # SSH public
    "/etc/ssh/ssh_config"
    "/etc/ssh/sshd_config"
    "/etc/ssh/ssh_host_rsa_key.pub"
    "/etc/ssh/ssh_host_dsa_key.pub"
    "/etc/ssh/ssh_host_ecdsa_key.pub"
    "/etc/ssh/ssh_host_ed25519_key.pub"

    # Das Zertifikat von *diesem* HOST
    "/etc/ssl/certs/ssl-cert-snakeoil.pem"

    # usbmount
    "/etc/usbmount"

    # VDR
    #"/etc/default/vdr"
    #"/var/lib/vdr/channels.conf"
    #"/etc/vdr/plugins/vnsiserver/allowed_hosts.conf"

    # Apport wurde deaktiviert
    "/etc/default/apport"

    # Drucker / Scanner
    "/etc/sane.d/pixma.conf"
    "/etc/cups"

    # grub Einstellungen (Änderungen müssen mit sudo update-grup eingerichtet
    # werden)
    "/etc/default/grub"

    # Festplatteneinstellungen
    "/etc/hdparm.conf"
    "/etc/udisks2"

    # locate / updatedb
    "/etc/updatedb.conf"

    # Energiesparmodelle: pm-utils
    "/etc/pm"

    # Samba (SMB) Server
    #"/etc/samba"

    # Apache
    #"/etc/apache2/apache2.conf"
    #"/etc/apache2/envvars"
    #"/etc/apache2/magic"
    #"/etc/apache2/ports.conf"
    #"/etc/apache2/conf-available"
    #"/etc/apache2/sites-available"

    # Apache: Intro Seite
    # "/var/www/html"
    # "/var/www/chrome"

    # Apache: Python WSGI
    # "/var/www/pyApps/helloWorld"

    # Apache: PHP
    # "/var/www/phpApps/helloWorld"

    # dovecot Mail Server
    "/etc/dovecot/dovecot.conf"
    "/etc/dovecot/conf.d"
    "/etc/rsyslog.d/60-dovecot.conf"

    # GitLab
    "/etc/gitlab/trusted-certs"

    # Postfix
    "/etc/postfix"
    "/etc/aliases"

    # Firefox Sync-Server
    "/home/mozcloud/syncserver/syncserver.ini"

    # Radicale
    "/etc/radicale"

    # VirtualBox
    "/etc/default/virtualbox"
    "/etc/vbox/autostart.db"
    "/etc/vbox/autostart.cfg"

    # boinc
    "/etc/default/boinc-client"
    "/etc/init.d/boinc-client"
    "/etc/boinc-client/remote_hosts.cfg"
)
