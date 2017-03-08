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
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GIT_USER="git"
GITLAB_WWW_USER="gitlab-www"
GITLAB_REDIS_USER="gitlab-redis"
GITLAB_PSQL_USER="gitlab-psql"

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
#     sudo gitlab-rake gitlab:backup:create SKIP=repositories
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
	    ;;
	deinstall)
            deinstall_gitlab
	    ;;
	*)
            echo
	    echo "usage $0 [(de)install]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
install_gitlab(){
    rstHeading "Installation GitLab CE"
# ----------------------------------------------------------------------------

    rstBlock "Das GitLab wird so eingerichtet, dass es über eine bestehende
Apache Installation im Netz verfügbar ist. Der URL Präfix ist 'gitlab', also
z.B.::

  https://$HOSTNAME/gitlab

Eine gute Beschreibung zum Setup einer gitlab Instanz findet man hier:

  https://docs.gitlab.com/omnibus/settings/configuration.html"

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

  sudo apt-get install postfix

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

    rstHeading "Einrichten des GitLab Setups" section

    rstBlock "Das Setup /etc/gitlab/gitlab.rb sollte wie folgt sein::"
    echo
    prefix_stdout <<EOF
external_url 'https://$HOSTNAME/gitlab'
git_data_dirs({"default" => "${GITLAB_REPO_FOLDER}"})

gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "127.0.0.1:8181"

nginx['enable'] = false
EOF
    waitKEY

    TEMPLATES_InstallOrMerge /etc/gitlab/gitlab.rb root root 644

    rstBlock "Richte Ordner für die Repositories ein ..."
    TEE_stderr <<EOF | bash | prefix_stdout
mkdir -p "${GITLAB_REPO_FOLDER}"
chown $GIT_USER:root  "$GITLAB_REPO_FOLDER"
EOF
    waitKEY

    rstBlock "Aktiviere Apache proxy_http und installiere gitlab site"
    a2enmod proxy_http
    APACHE_install_site gitlab
    waitKEY

    gitlab-ctl reconfigure
}


# ----------------------------------------------------------------------------
deinstall_gitlab(){
    rstHeading "Deinstallation GitLab CE"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG: ${_color_Off}

    Folgende Aktion löscht die GitLab samt Konfiguration!"

    if ! askNy "Wollen sie WIRKLICH die Konfiguration löschen?"; then
        return 42
    fi
    aptPurgePackages ${GITLAB_PACKAGES}

    if askNy "Sollen die 'Reste' aus /opt/gitlab auch entfernt werden?"; then
        echo
        TEE_stderr <<EOF | bash | prefix_stdout
rm -rf /opt/gitlab/
EOF
    fi

    rstBlock "Die Anwendungsdaten unter /var/opt/gitlab/ als auch die
Reposetories unter ${GITLAB_REPO_FOLDER} wurden nicht gelöscht. Diese müssen
ggf. gesichert und anschließend gelöscht werden."
    waitKEY

}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
