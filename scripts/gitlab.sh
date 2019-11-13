#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     gitlab setup with apache as proxy
# ----------------------------------------------------------------------------

# https://about.gitlab.com/downloads

# https://docs.gitlab.com/omnibus/settings/configuration.html#configuring-a-relative-url-for-gitlab
# https://docs.gitlab.com/omnibus/settings/configuration.html#relative-url-troubleshooting

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GIT_USER="git"
GITLAB_WWW_USER="gitlab-www"
GITLAB_REDIS_USER="gitlab-redis"
GITLAB_PSQL_USER="gitlab-psql"

GITLAB_LOG_FOLDER="/var/log/gitlab"
GITLAB_DATA_FOLDER="/var/opt/gitlab"
GITLAB_CONFIG_FOLDER="/etc/gitlab"
# Achtung: der Ordner mit den Git-Reposetories darf kein symbolischer Link sein
GITLAB_REPO_FOLDER="/share/repos/gitlab"

GITLAB_DEB_SCRIPT_URL="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"

GITLAB_PACKAGES="\
  gitlab-ce \
"
REQUIRE_PACKAGES="\
  openssh-server ca-certificates \
"

CONFIG_BACKUP=(
    "/etc/gitlab/trusted-certs"
)

CONFIG_BACKUP_ENCRYPTED=(
    "/etc/gitlab/gitlab.rb"
    "/etc/gitlab/gitlab-secrets.json"
)

# Backup: Man kann alles mit den Tools von gitlab sichern, das finde ich aber
# teilweise unpraktisch, da es nicht in jedes (resp. mein) Sicherungskonzept
# passt.
#
#   https://docs.gitlab.com/ce/raketasks/backup_restore.html#create-a-backup-of-the-gitlab-system
#
# Ich würde die Reposetories sichern, indem ich Clone davon anlege. Den Rest
# kann man dann z.B. wie folgt machen::
#
#     sudo -H gitlab-rake gitlab:backup:create SKIP=repositories
#
# Oder man macht ein rsync der gesammten Installationsdaten unter
# /var/opt/gitlab/ was vermutlich am einfachsten ist (und mit Hardlinks
# sicherlich auch am sparsamsten).

DATA_BACKUP=(
    "/share/repos/gitlab"
)

# ----------------------------------------------------------------------------
main(){
    rstHeading "GitLab CE" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
            install_gitlab
            sudoOrExit
	    ;;
	deinstall)
            sudoOrExit
            deinstall_gitlab
	    ;;
        README)
            rstHeading "README"
            README_GITLAB
            README_LDAP
            ;;
	*)
            echo
	    echo "usage $0 [(de)install|README]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
README_GITLAB(){
# ----------------------------------------------------------------------------

    rstBlock "Das GitLab wird mit diesem Script so eingerichtet, dass es über
eine bestehende Apache Installation im Netz verfügbar ist. Präfix der URL ist
'gitlab', also z.B.::

  https://$HOSTNAME/gitlab

Eine gute Beschreibung zum Setup einer gitlab Instanz findet man hier:

  https://docs.gitlab.com/omnibus/settings/configuration.html"

}


# ----------------------------------------------------------------------------
README_LDAP(){
    rstHeading "GitLab LDAP auth" section
# ----------------------------------------------------------------------------

    echo -e "
Die Authentifizierung der GitLab Benutzer kann auch über den LDAP Dienst
erfolgen, eine Beschreibung findet man hier::

  https://docs.gitlab.com/ce/administration/auth/ldap.html

Im Folgenden wird stichwortartig ein einfaches openLDAP Setup vorgestellt, mit
dem Services wie 'gitlab' administriert werden können.

1. Das Setup benötigt das openLDAP Overlay 'memberOf'.

   siehe : templates/etc/ldap/memberof_overlay.ldif

2. Im LDAP eine 'ou=Services,dc=example,dc=org' einrichten und in der eine
   *groupOfNames* 'cn=gitlab,ou=Services,dc=example,dc=org' einrichten.

   siehe : templates/etc/ldap/add_services.ldif

3. Die Benutzerverwaltung im LDAP muss über Felder wie 'mail', 'cn', 'givenName'
   und 'sn' verfügen. Für die ldapscripts eignet sich beispielsweise folgendes
   Template, mit dem die Benutzer sowohl für POSIX Accounts als auch
   für WEB-Dienste (*inetOrgPerson*) genutzt werden können::

       dn: uid=<user>,<usuffix>,<suffix>
       objectClass: top
       objectClass: person
       objectClass: organizationalPerson
       objectClass: inetOrgPerson
       objectClass: posixAccount
       cn: <user>
       uid: <user>
       uidNumber: <uid>
       gidNumber: <gid>
       homeDirectory: <home>
       loginShell: <shell>
       gecos: <user>
       description: User account
       displayName: <user>
       givenName: <ask>
       sn: <ask>
       mail: <ask>

   Wer die ldapscripts nutzt sollte sich gleich die Templates installieren.

   siehe : templates/etc/ldapscripts/*.template

Mit den wenigen Schritten ist schon die Basis zur Verwaltung von Diensten und
deren Membern im LDAP gelegt. In 'cn=gitlab,ou=Services,dc=example,dc=org'
können nun die Benutzer hinzugefügt werden z.B.::

   member: uid=test_user,ou=Users,dc=example,dc=org

4. Einrichten LDAP im gitlab. In der Datei templates/etc/gitlab/gitlab.rb ist
   ein (auskommentiertes) Setting für obiges LDAP Setup bereits eingetragen.
   Es müssen die Werte für:

   * gitlab_rails['ldap_enabled']
   * gitlab_rails['ldap_servers']

   aktiviert und ggf. angepasst werden. Danach noch einmal::

     gitlab-ctl reconfigure

Über den *memberOf* Filter '(memberOf=cn=gitlab,ou=Services,dc=example,dc=org)'
in der gitlab Konfiguration wird sichergestellt, dass sich nur solche
LDAP-Benutzer im gitlab einloggen können, die auch *member* der *groupOfNames*
('cn=gitlab,ou=Services,dc=example,dc=org') sind.
"
}

# ----------------------------------------------------------------------------
install_gitlab(){
    rstHeading "Installation GitLab CE"
# ----------------------------------------------------------------------------

    README_GITLAB
    if ! askYn "Soll GitLab CE installiert werden?"; then
        return 42
    fi

    if ! aptPackageInstalled apache2; then

        rstBlock "Apache is noch nicht installiert, die Installation sollte mit
dem Skript 'apache_setup.sh' durchgeführt werden."
        return 42
    fi

    if ! aptPackageInstalled postfix; then
        echo -e "
GitLab benötigt den SMTP Server postfix, der derzeit noch nicht installiert ist.
Die postfix Installation kann über das Script 'postfix.sh' vorgenommen werden
(siehe auch 'dovecot.sh'). Alternativ kann jetzt eine einfache Installation via

  sudo -H apt-get install postfix

vorgenommen werden, bei der 'Nur lokal' ausgewählt werden sollte."

        if ! askNy "Soll eine einfache Installation des postfix erfolgen"; then
            return 42
        fi
        apt-get install postfix
    fi

    rstHeading "Einrichten der APT-Paketquellen 'packages.gitlab.com'" section

    echo -e "\nAPT Paketquellen ..."
    cacheDownload "$GITLAB_DEB_SCRIPT_URL" gitlab.deb.sh askNy
    chmod ugo+x ${CACHE}/gitlab.deb.sh
    ${CACHE}/gitlab.deb.sh
    echo
    cat /etc/apt/sources.list.d/gitlab_gitlab-ce.list | prefix_stdout
    waitKEY

    REQUIRE_PACKAGES
    TITLE="Installation der Pakete ..."\
         DEBIAN_FRONTEND=noninteractive \
         aptInstallPackages ${GITLAB_PACKAGES} ${REQUIRE_PACKAGES}

    rstBlock "Es wird sichergestellt, dass alle Services beendet sind."
    TEE_stderr <<EOF | bash | prefix_stdout
gitlab-ctl stop
EOF

    rstHeading "Ordner für die Repositories" section
    echo
    if ! getent passwd $GIT_USER > /dev/null ; then
        useradd -r -d "${GITLAB_DATA_FOLDER}" -s /bin/sh $GIT_USER
    fi

    TEE_stderr <<EOF | bash | prefix_stdout
mkdir -p "${GITLAB_REPO_FOLDER}"
chown $GIT_USER:root  "$GITLAB_REPO_FOLDER"
chmod 700 "$GITLAB_REPO_FOLDER"
EOF
    waitKEY

    if [[ -e $GITLAB_REPO_FOLDER ]]; then
        if ! [[ "$(readlink -f $GITLAB_REPO_FOLDER)" == "$GITLAB_REPO_FOLDER" ]]; then
            rstBlock "${BRed}ACHTUNG:${_color_Off}\n$GITLAB_REPO_FOLDER darf kein symbolischer link
sein! Es wird $(readlink -f $GITLAB_REPO_FOLDER) verwendet!"
            GITLAB_REPO_FOLDER="$(readlink -f $GITLAB_REPO_FOLDER)"
        fi
    fi

    rstHeading "Einrichten des GitLab Setups" section

    rstBlock "Das Setup ${GITLAB_CONFIG_FOLDER}/gitlab.rb sollte wie folgt sein::"

    prefix_stdout <<EOF
external_url 'https://$HOSTNAME/gitlab'
git_data_dirs({"default" => "${GITLAB_REPO_FOLDER}"})

gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "127.0.0.1:8181"

nginx['enable'] = false

gitlab_rails['manage_backup_path'] = true
gitlab_rails['backup_path'] = "/share/backups/gitlab"
EOF
    waitKEY

    TEMPLATES_InstallOrMerge ${GITLAB_CONFIG_FOLDER}/gitlab.rb root root 644

    rstHeading "Apache proxy_http und gitlab-site"
    echo
    a2enmod proxy_http
    APACHE_install_site gitlab
    waitKEY

    rstHeading "GitLab reconfigure"
    echo
    gitlab-ctl reconfigure
    waitKEY

    rstHeading "GitLab Installation abgeschlossen"

    rstBlock "Beim dem erstmaligen aufrufen der Adresse:

  https://$HOSTNAME/gitlab

wird nach einem Passwort gefragt. Dies ist das Passwort für den Benutzer mit dem
*Username* 'root'. Will man sich als dieser Benutzer einloggen, dann verwendet
man dafür eben diesen *Username* (und keine eMail Adresse)."

}


# ----------------------------------------------------------------------------
deinstall_gitlab(){
    rstHeading "Deinstallation GitLab CE"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG:${_color_Off}

    Folgende Aktion löscht die GitLab samt Konfiguration!"

    if ! askNy "Wollen sie WIRKLICH die Konfiguration löschen?"; then
        return 42
    fi

    rstHeading "Apache Site *disable*" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
a2dissite gitlab
systemctl force-reload apache2
EOF

    APACHE_dissable_site gitlab

    aptPurgePackages ${GITLAB_PACKAGES}

    rstHeading "Aufräumen" section

    if askNy "Sollen die 'Reste' aus ${BYellow}/opt/gitlab${_color_Off} auch entfernt werden?"; then
        echo
        TEE_stderr <<EOF | bash | prefix_stdout
rm -rf /opt/gitlab/
EOF
    fi

    echo -e "
Folgende Dateien bzw. Ordner wurden nicht gelöscht:

* Anwendungsdaten: ${BYellow}${GITLAB_DATA_FOLDER}${_color_Off}
* Reposetories:    ${BYellow}${GITLAB_REPO_FOLDER}${_color_Off}
* Konfiguration:   ${BYellow}${GITLAB_CONFIG_FOLDER}${_color_Off}
* Log-Dateien:     ${BYellow}${GITLAB_LOG_FOLDER}${_color_Off}

Diese müssen ggf. gesichert und anschließend gelöscht werden."

    waitKEY
    rstBlock "Folgende Benutzer wurden bei der Installation angelegt, wurden
aber hier bei der Deinstallation nicht wieder entfernt. Die Benutzer können mit
dem Kommando 'userdel <user-login>' gelöscht werden.
"
    TEE_stderr <<EOF | bash | prefix_stdout
getent passwd $GIT_USER $GITLAB_WWW_USER $GITLAB_REDIS_USER $GITLAB_PSQL_USER
EOF

    if askYn "Sollen die Paketquellen für gitlab_gitlab-ce auch entfernt werden?"; then
        aptRemoveRepository gitlab_gitlab-ce
    fi
    waitKEY

}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
