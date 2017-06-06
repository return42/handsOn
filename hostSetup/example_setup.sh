#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose: host setup file
# ----------------------------------------------------------------------------


ORGANIZATION="darmarIT"

# =====================
# Debian's Apache Setup
# =====================

# APACHE_SETUP="/etc/apache2"
# APACHE_SITES_AVAILABE="${APACHE_SETUP}/sites-available"
# APACHE_MODS_AVAILABE="${APACHE_SETUP}/mods-available"
# APACHE_CONF_AVAILABE="${APACHE_SETUP}/conf-available"

APACHE_ADD_SITES="\
  fxSyncServer\
  OnlineDoc\
"

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

# ----------------------------------------------------------------------------
# Verschlüsseltes Backup von Konfigurationen
# ----------------------------------------------------------------------------

CONFIG_BACKUP_ENCRYPTED=(

    # ACHTUNG:
    #
    #   Die Dateien werden normalerweise in der Sicherung für *alle* lesbar
    #   gesichert. Will man z.B. Schlüssel und Passwörter sichern, muss man die
    #   mit einer Passphrase verschlüsseln. Die hier gelisteten Daten werden
    #   entsprechend verschlüsselt.

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

)

# ----------------------------------------------------------------------------
# Backup von Konfigurationsdateien
# ----------------------------------------------------------------------------

CONFIG_BACKUP=(

    # Die Cron-Jobs der Backup Strategie
    "/etc/cron.daily/example_backup"
    "/etc/cron.hourly/spindownHD"

    "/etc/fstab"
    "/etc/rsyslog.conf"
    "/etc/modules"
    "/etc/rc.local"
    "/etc/logrotate.d/sdk-common"

    # SSH public
    "/etc/ssh/ssh_config"
    "/etc/ssh/sshd_config"
    "/etc/ssh/ssh_host_rsa_key.pub"
    "/etc/ssh/ssh_host_dsa_key.pub"
    "/etc/ssh/ssh_host_ecdsa_key.pub"
    "/etc/ssh/ssh_host_ed25519_key.pub"

    # Das Zertifikat von *diesem* HOST
    "/etc/ssl/certs/ssl-cert-snakeoil.pem"

    # OpenLDAP
    "/etc/ldap"
    "/etc/ldap.conf"
    "/etc/default/slapd"
    "/etc/ldapscripts/ldapscripts.conf"

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

    # dovecot Mail Server
    "/etc/dovecot/dovecot.conf"
    "/etc/dovecot/conf.d"
    "/etc/rsyslog.d/60-dovecot.conf"

    # Postfix
    "/etc/postfix"
    "/etc/aliases"

    # Apport wurde deaktiviert
    "/etc/default/apport"

    # grub Einstellungen (Änderungen müssen mit "sudo update-grub" eingerichtet
    # werden)
    "/etc/default/grub"

    # Festplatteneinstellungen
    "/etc/hdparm.conf"
    "/etc/udisks2"

    # usbmount
    "/etc/usbmount"

    # locate / updatedb
    "/etc/updatedb.conf"

    # Einergiesparmodelle: pm-utils
    "/etc/pm"

    # Samba (SMB) Server
    "/etc/samba"

    # Apache
    "/etc/apache2/apache2.conf"
    "/etc/apache2/envvars"
    "/etc/apache2/magic"
    "/etc/apache2/ports.conf"
    "/etc/apache2/conf-available"
    "/etc/apache2/sites-available"

    # Apache: Intro Seite
    "/var/www/html"

    # Apache: Python WSGI
    "/var/www/pyApps/helloWorld"
    "/var/www/pyApps/lodgeit.wsgi"

    # Apache: PHP
    "/var/www/phpApps/helloWorld"

    # GitLab
    "/etc/gitlab/trusted-certs"

    # Firefox Sync-Server
    "/home/mozcloud/syncserver/syncserver.ini"

    # Radicale
    "/etc/radicale"

    # VirtualBox
    "/etc/default/virtualbox"
    "/etc/vbox/autostart.db"
    "/etc/vbox/autostart.cfg"

)

