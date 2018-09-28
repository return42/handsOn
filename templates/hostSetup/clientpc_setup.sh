#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose: host setup file
# ----------------------------------------------------------------------------

LDAP_SERVER="storage" # "storage.fritz.box" or "storage"
SAMBA_SERVER="storage" # "storage.fritz.box" or "storage"
ORGANIZATION="darmarIT"

# ----------------------------------------------------------------------------
# Verschlüsseltes Backup von Konfigurationen
# ----------------------------------------------------------------------------

CONFIG_BACKUP_ENCRYPTED=(

    # ACHTUNG:
    #
    #   Die Dateien werden in der Sicherung für *alle* lesbar gesichert. Will
    #   man Schlüssel/Passwörter sichern, muss man die mit einer Passphrase
    #   verschlüsseln.

    "/etc/ssl/private"

    # SSH private
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_dsa_key"
    "/etc/ssh/ssh_host_ecdsa_key"
    "/etc/ssh/ssh_host_ed25519_key"
)

# ----------------------------------------------------------------------------
# Backup von Konfigurationsdateien
# ----------------------------------------------------------------------------

CONFIG_BACKUP=(

    # LDAP-Client
    "/etc/ldap.conf"
    "/etc/ldap/ldap.conf"

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
    # "/etc/fstab"
    "/etc/rsyslog.conf"
    "/etc/modules"
    "/etc/rc.local"

    # SSH public
    # "/etc/ssh/ssh_config"
    # "/etc/ssh/sshd_config"
    # "/etc/ssh/ssh_host_rsa_key.pub"
    # "/etc/ssh/ssh_host_dsa_key.pub"
    # "/etc/ssh/ssh_host_ecdsa_key.pub"
    # "/etc/ssh/ssh_host_ed25519_key.pub"

    # Das Zertifikat von *diesem* HOST
    # "/etc/ssl/certs/ssl-cert-snakeoil.pem"

    # VDR
    #"/etc/default/vdr"
    #"/var/lib/vdr/channels.conf"
    #"/etc/vdr/plugins/vnsiserver/allowed_hosts.conf"

    # Apport wurde deaktiviert
    "/etc/default/apport"

    # Drucker / Scanner
    # "/etc/sane.d/pixma.conf"
    # "/etc/cups"

    # grub Einstellungen (Änderungen müssen mit sudo update-grup eingerichtet
    # werden)
    "/etc/default/grub"

    # Festplatteneinstellungen
    # "/etc/hdparm.conf"
    # "/etc/udisks2"

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

    # boinc
    # "/etc/default/boinc-client"
    # "/etc/init.d/boinc-client"
    # "/etc/boinc-client/gui_rpc_auth.cfg"
    # "/etc/boinc-client/remote_hosts.cfg"
)

