#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     gitlab setup with apache as proxy
# ----------------------------------------------------------------------------

# https://about.gitlab.com/downloads

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GITLAB_USER="git"
GITLAB_DEB_SCRIPT_URL="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"
GITLAB_PACKAGES="\
  gitlab-ce \
"
REQUIRE_PACKAGES="\
  openssh-server ca-certificates \
"

DATA_BACKUP=(
    # "/var/mail"
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
        info)
            info
            ;;
	*)
            echo
	    echo "usage $0 [(de)install|info]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
install_gitlab(){
    rstHeading "Installation GitLab CE"
# ----------------------------------------------------------------------------

    if ! askYn "Soll GitLab CE installiert werden?"; then
        return 42
    fi
    rstBlock "Das GitLab wird so eingerichtet, dass es über eine bestehende
Apache Installation im Netz verfügbar ist."

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

    # rstHeading "Einrichten der APT-Paketquellen 'packages.gitlab.com'" section
    # echo -e "\nAPT Paketquellen ..."
    # cacheDownload "$GITLAB_DEB_SCRIPT_URL" gitlab.deb.sh askNy
    # chmod ugo+x ${CACHE}/gitlab.deb.sh
    # ${CACHE}/gitlab.deb.sh
    # echo
    # cat /etc/apt/sources.list.d/gitlab_gitlab-ce.list | prefix_stdout
    # waitKEY

    # REQUIRE_PACKAGES
    # TITLE="Installation der Pakete"\
    #      DEBIAN_FRONTEND=noninteractive \
    #      aptInstallPackages ${GITLAB_PACKAGES} ${REQUIRE_PACKAGES}

    rstHeading "Einrichten des GitLab Setups" section
    TEMPLATES_InstallOrMerge /etc/gitlab/gitlab.rb root root 644
    a2enmod proxy_http
    APACHE_install_site gitlab
    waitKEY
 
    gitlab-ctl reconfigure
 


    rstBlock "ist noch nicht weiter implementiert ... siehe info"

}


# ----------------------------------------------------------------------------
deinstall_gitlab(){
    rstHeading "Deinstallation GitLab CE"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG: ${_color_Off}

    Folgende Aktion löscht die GitLab Konfiguration"

    if ! askNy "Wollen sie WIRKLICH die Konfiguration löschen?"; then
        return 42
    fi
    rstBlock "ist noch nicht weiter implementiert ... siehe info"
    #aptPurgePackages ${GITLAB_PACKAGES}
}

# ----------------------------------------------------------------------------
info(){
# ----------------------------------------------------------------------------

    echo -e "
lorem ...
"

    waitKEY

    # if aptPackageInstalled xxxxx; then
    #     echo "NN"
    # fi
}



# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
