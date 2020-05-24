#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     Desktop Setup
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

GNOME3_PPA="ppa:gnome3-team/gnome3"
GNOME_SHELL_EXTENSIONS="/usr/share/gnome-shell/extensions"

# gnome-shell extension: dash-to-dock
#
# HINT: https://github.com/micheleg/dash-to-dock/issues/902 Current master
#       dropped support for Gnome shell <3.32 [26feddb], so this is
#       expected. The current updated branch for previous versions (down to
#       3.18) is https://github.com/micheleg/dash-to-dock/tree/gnome-3.30.

if dpkg --compare-versions "18.10" "lt" "$DISTRIB_RELEASE"; then
    DASH_TO_DOCK_BRANCH="${DASH_TO_DOCK_BRANCH:-gnome-3.32}"
else
    DASH_TO_DOCK_BRANCH="${DASH_TO_DOCK_BRANCH:-gnome-3.30}"
fi

# dconf-editor gconf-editor
# -------------------------
#
# - https://wiki.ubuntuusers.de/GNOME_Konfiguration/#gconf-und-dconf
# - https://wiki.gnome.org/Initiatives/GnomeGoals/GSettingsMigration

GNOME3_PACKAGES="\
 language-pack-gnome-de \
 gnome-core gnome-screenshot\
 gnome-session \
 gnome-getting-started-docs-de \
 gnome-power-manager gnome-tweak-tool \
 dconf-editor gconf-editor \
 gnome-packagekit vanilla-gnome-desktop \
 elementary-icon-theme \
 gir1.2-gtop-2.0 gir1.2-gconf-2.0 gir1.2-clutter-1.0 \
 tracker tracker-extract tracker-miner-fs \
 gnome-clocks \
"
# ubuntu-gnome-default-settings \
# flameshot: läuft aktuell (19.04) wohl nur mit xorg (kein Wayland support)

DISPLAY_MANAGER_PACKAGES="\
  gdm3 \
"
#  sddm \
#  kdm \
#  ldm \

CINNAMON_PACKAGES="cinnamon-desktop-environment"
MATE_PACKAGES="\
  mate-desktop mate-desktop-common mate-desktop-environment-core\
  mate-notification-daemon-common\
  mate-polkit-common"

UNITY_REMOVE_PACKAGES="$(dpkg-query -f '${binary:Package} ' -W 'unity*') \
 ubuntu-gnome-desktop ubuntu-gnome-wallpapers-* \
 ubuntu-session ubuntu-desktop \
"

# elementary
# ----------
#
# Die Installation ist nicht mit ubuntu 15.04 oder 15.10 möglich. Erst ab 16.04
# scheint es wieder einen Support in dem PPA zu geben (zumindest in daily
# scheint was vorgesehen).
#
# Bevor man das PPA wechselt sollte man zuvor remove_elementary aufgerufen
# haben. Ansonsten verbleiben ggf. noch *Paketreste* aus dem alten PPA.
#
# siehe https://launchpad.net/~elementary-os
#
#ELEMENTARY_PPA="ppa:elementary-os/stable"
#ELEMENTARY_PPA="ppa:elementary-os/daily"
ELEMENTARY_PPA="ppa:elementary-os/staging"

# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF

usage:
  $(basename $0) [chooseDM]
  $(basename $0) install [GNOME[-ext|-dconf]]|GNOME3-PPA|elementary|cinnamon|mate|solaar]
  $(basename $0) remove  [GNOME-ext]]|[unity|GNOME3-PPA|elementary|cinnamon|mate|solaar]

- GNOME: volle Installation GNOME3-Shell https://wiki.gnome.org/Projects/GnomeShell
- GNOME-ext: Empfohlene Shell-Extensions https://extensions.gnome.org/
- GNOME-dconf: Anpassungen GNOME-Defaluts https://wiki.gnome.org/Projects/dconf/SystemAdministrators
- GNOME3-PPA: PPA für GNOME3, ab ubuntu 18.04 nicht mehr erforderlich
- nemo: Installation des Dateibrowsers Nemo
- solaar: Linux-Gerätemanager für eine Vielzahl von Logitech-Geräten.

Für ältere Ubuntu Versionen (<18.04):
- elementary: Desktop des elementary-OS https://elementary.io/#desktop-development
- cinnamon: Alter GNOME-Desktop, der von Linux-Mint weiter entwickelt wird
- mate: Mate-Desktop https://mate-desktop.org/

EOF
}


# ----------------------------------------------------------------------------
main(){
    rstHeading "Desktop System" part
# ----------------------------------------------------------------------------

    case $1 in
	--source-only)  ;;
        -h|--help) usage;;

        chooseDM) chooseDM ;;
        install)
	    sudoOrExit
            case $2 in
                GNOME3-PPA)   install_gnome3_ppa   ;;
                GNOME)        install_gnomeShell   ;;
                GNOME-ext)    install_gnome_extensions ;;
		GNOME-dconf)  install_dconf_defaults ;;
		nemo)         install_nemo ;;
                elementary)   install_elementary   ;;
	        cinnamon)     TITLE="Installation Cinnamon-Desktop" aptInstallPackages ${CINNAMON_PACKAGES}    ;;
	        mate)         TITLE="Installation Mate-Desktop"  aptInstallPackages ${MATE_PACKAGES}           ;;
		solar)        TITLE="Installation Solaar"  aptInstallPackages solaar ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"exit 42;;
            esac  ;;
        remove)
	    sudoOrExit
            case $2 in
                GNOME3-PPA)   remove_gnome3_ppa   ;;
                GNOME-ext)    remove_gnome_extensions ;;
                elementary)   remove_elementary   ;;
                unity)        remove_unity ;;
		nemo)         remove_nemo ;;
                cinnamon)     TITLE="De-Installation Cinnamon-Desktop" aptPurgePackages ${CINNAMON_PACKAGES}   ;;
                mate)         TITLE="De-Installation Mate-Desktop" aptPurgePackages ${MATE_PACKAGES}           ;;
		solar)        TITLE="De-Installation Solaar"  aptPurgePackages solaar ;;
                *)       usage "${BRed}ERROR:${_color_Off} unknown or missing $1 command $2"; exit 42;;
            esac  ;;
        *) usage "${BRed}ERROR:${_color_Off} unknown or missing command $1"; exit 42
    esac
}


# ----------------------------------------------------------------------------
chooseDM() {
    rstHeading "Auswahl eines DISPLAY Managers"
# ----------------------------------------------------------------------------
    echo
    apt-get install -y ${DISPLAY_MANAGER_PACKAGES}
    waitKEY
}


# ----------------------------------------------------------------------------
install_nemo() {
    rstHeading "Installation des Dateibrowsers Nemo"
# ----------------------------------------------------------------------------

    local PPA='add-apt-repository ppa:embrosyn/cinnamon'

    rstBlock "Installation des Nemo Dateibrowsers aus dem ($PPA).

Nemo wird als default Dateibrowser eingerichtet.  Die Desktop Icons werden über
nemo-desktop realisiert und die GNOME Erweiterung für Desktop Icons wird
deaktiviert."

    if dpkg --compare-versions "18.04" ">=" "$DISTRIB_RELEASE"; then
	rstBlock "Diese Installation ist erst ab 18.04 möglich."
	return
    fi

    if askYn "Soll die Installation durchgeführt werden?"; then

	apt-get -y purge nemo
	apt-get -y autoremove
	add-apt-repository -u $PPA
	apt-get -y install nemo

	xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

	TEMPLATES_InstallOrMerge "/etc/xdg/autostart/nemo-desktop.desktop" root root 644

	TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/00_nautilus_settings" root root 644
	TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/10_nemo_settings" root root 644
	dconf update
	info_msg "Alle Änderungen werden erst mit einer Neuanmeldung aktiv."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
remove_nemo() {
    rstHeading "De-Installation des Dateibrowsers Nemo"
# ----------------------------------------------------------------------------

    local PPA='add-apt-repository ppa:embrosyn/cinnamon'

    rstBlock "Es wird Nemo und das PPA ($PPA) deinstalliert."
    if askYn "Soll die Installation durchgeführt werden?"; then

	apt-get -y purge nemo
	apt-get -y autoremove
	add-apt-repository -u -r $PPA

	xdg-mime default org.gnome.Nautilus.desktop inode/directory application/x-gnome-saved-search

	rm -f "/etc/xdg/autostart/nemo-desktop.desktop"

	TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/00_nautilus_settings" root root 644
	rm -f "/etc/dconf/db/site.d/10_nemo_settings"
	dconf update
	info_msg "Alle Änderungen werden erst mit einer Neuanmeldung aktiv."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
install_elementary() {
    rstHeading "Installation elementary"
# ----------------------------------------------------------------------------

    rstBlock ".. hint::

  Die Installation ist nicht mit ubuntu 15.04 oder 15.10 möglich. Erst
  ab 16.04 scheint es wieder einen Support in dem PPA zu geben."

    if askYn "Soll die Installation durchgeführt werden?"; then
        echo
        rstBlock "deinstaliere ggf. vorhandene Pakete"
        apt-get purge elementary-desktop
        waitKEY

        rstBlock "add PPA: ${Yellow}${ELEMENTARY_PPA}${_color_Off}"
        add-apt-repository --yes "${ELEMENTARY_PPA}"
        waitKEY

        apt-get update
        apt-get install elementary-desktop
    else
        rstBlock "Installation von elementary-desktop abgebrochen."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
remove_elementary() {
    rstHeading "De-Installation elementary"
# ----------------------------------------------------------------------------

    rstBlock "deinstaliere ggf. vorhandene Pakete"
    apt-get purge elementary-desktop
    waitKEY
    rstBlock "remove PPA: ${Yellow}${ELEMENTARY_PPA}${_color_Off}"
    add-apt-repository --yes --remove "${ELEMENTARY_PPA}"
    apt-get update
    waitKEY
}

# ----------------------------------------------------------------------------
install_gnome3_ppa() {
    rstHeading "GNOME3 Team PPA"
# ----------------------------------------------------------------------------

    rstBlock ".. hint::

  Die Installation des PPA für die GNOME3 Shell ist mit ubuntu 18.04 nicht mehr
erforderlich."

    if askYn "Soll gnome3 PPA eingerichtet werden?"; then
        apt-get install -y ppa-purge
	ppa-purge ${GNOME3_PPA}
        add-apt-repository --yes "${GNOME3_PPA}"
        waitKEY
        apt-get update
    else
        rstBlock "Setup des PPA abgebrochen."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
remove_gnome3_ppa() {
    rstHeading "Deinstallation GNOME3 Team PPA"
# ----------------------------------------------------------------------------

    echo
    if askYn "Soll gnome3 ppa entfernt werden?"; then
        apt-get install -y ppa-purge
	ppa-purge ${GNOME3_PPA}
        add-apt-repository --yes --remove "${GNOME3_PPA}"
        waitKEY
        apt-get update
    else
        rstBlock "Emtfernen des PPA wurde abgebrochen."
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
remove_unity(){
    rstHeading "De-Installation von Unity"
# ----------------------------------------------------------------------------

    rstPkgList ${UNITY_REMOVE_PACKAGES}
    if askYn "Soll Unity komplett deinstalliert werden?"; then
        apt-get purge --ignore-missing -y ${UNITY_REMOVE_PACKAGES}
        apt-get -y autoremove
    fi
}

# ----------------------------------------------------------------------------
install_gnome_extensions(){
    rstHeading "Installation der Gnome-Shell Extensions"
# ----------------------------------------------------------------------------

    local _origin=
    local _name=
    local _dst=
    local _ws=

    rstHeading "gnome-shell: Desktop Icons NG" section

    waitKEY "TODO: https://gitlab.com/rastersoft/desktop-icons-ng.git"

    rstHeading "gnome-shell: dash to dock" section
    echo
    _origin="https://github.com/micheleg/dash-to-dock.git"
    _name="dash-to-dock@micxgx.gmail.com"
    _ws="${CACHE}/${_name}"

    if [[ -d "${_ws}" ]] ; then
	info_msg "${Green}already cloned:${_color_Off} $1"
        info_msg "  -->${Green} ${target_folder} ${_color_Off}"
	pushd "${_ws}" > /dev/null
        if [[ ! -z ${SUDO_USER} ]]; then
            sudo -u ${SUDO_USER} git fetch --all
        else
            git fetch --all
        fi
	popd > /dev/null
    else
	cloneGitRepository "$_origin" "$_name"
    fi

    rstBlock "checkout ${DASH_TO_DOCK_BRANCH} ..."
    pushd "$_ws" > /dev/null
    git checkout ${DASH_TO_DOCK_BRANCH}

    rstBlock "run make ..."

    if [[ ! -z ${SUDO_USER} ]]; then
        sudo -u ${SUDO_USER} make | prefix_stdout
    else
       make | prefix_stdout
    fi

    TEE_stderr 1 <<EOF | bash | prefix_stdout
DESTDIR=/ make install
EOF
    popd > /dev/null
    waitKEY

    rstHeading "gnome-shell: system-monitor" section
    echo

    if dpkg --compare-versions "19.10" "gt" "$DISTRIB_RELEASE"; then
        apt install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0
    else
        apt install gir1.2-gtop-2.0
    fi
    echo
    # FIXME: interim solution as long as #469 is open
    # [#469] https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet/issues/496
    _origin="https://github.com/return42/gnome-shell-system-monitor-applet.git"
    _name="system-monitor@paradoxxx.zero.gmail.com"
    _dst="${GNOME_SHELL_EXTENSIONS}/$_name"
    _ws="${CACHE}/${_name}"
    cloneGitRepository "$_origin" "$_name"
    rstBlock "Aus dem Repo wird der Unter-Ordner $_name installiert"
    TEE_stderr 1 <<EOF | bash | prefix_stdout
cd "${_ws}"
sudo -u ${SUDO_USER} make build
DESTDIR= make install
EOF
    waitKEY

#     rstHeading "gnome-shell: tracker-search-provider" section
#     echo
#     _origin="https://github.com/hamiller/tracker-search-provider.git"
#     _name="tracker-search-provider@sinnix.de"
#     _dst="${GNOME_SHELL_EXTENSIONS}/$_name"
#     _ws="${CACHE}/${_name}"
#     cloneGitRepository "$_origin" "$_name"
#     rstBlock "Aus dem Repo (branch gnome_16) werden die zwei Dateien in Ordner
# $_name installiert"
#     TEE_stderr 1 <<EOF | bash | prefix_stdout
# rm -rf "$_dst"
# mkdir -p "$_dst"
# cd "${_ws}"
# git checkout -f gnome_16
# cp -r extension.js metadata.json "$_dst"
# EOF
#     waitKEY

    rstHeading "Liste installierter Extensions" section
    TEE_stderr 1 <<EOF | bash | prefix_stdout
ls -la ${GNOME_SHELL_EXTENSIONS}
EOF
    waitKEY


}


# ----------------------------------------------------------------------------
remove_gnome_extensions(){
    rstHeading "De-Installation der Gnome-Shell Extensions"
# ----------------------------------------------------------------------------

    rstHeading "gnome-shell: dash to dock" section
    _name="dash-to-dock@micxgx.gmail.com"
    _dst="${GNOME_SHELL_EXTENSIONS}/$_name"
    TEE_stderr <<EOF | bash | prefix_stdout
rm -rf "$_dst"
EOF
    waitKEY

    rstHeading "gnome-shell: system-monitor" section
    _name="system-monitor@paradoxxx.zero.gmail.com"
    _dst="${GNOME_SHELL_EXTENSIONS}/$_name"
    TEE_stderr <<EOF | bash | prefix_stdout
rm -rf "$_dst"
EOF
    waitKEY

    rstHeading "gnome-shell: tracker-search-provider" section

    _name="tracker-search-provider@sinnix.de"
    _dst="${GNOME_SHELL_EXTENSIONS}/$_name"
    TEE_stderr <<EOF | bash | prefix_stdout
rm -rf "$_dst"
EOF
}

# ----------------------------------------------------------------------------
install_dconf_defaults(){
    rstHeading "Installation angepasster 'dconf' Defaults"
# ----------------------------------------------------------------------------

    rstBlock "\
Die GNOME Einstellungen werden in den \*dconf\* Settings verwaltet
(siehe 'dconf - System Administrator Guide' [1]).

Im Folgenden werden einige GNOME-Defaults geändert, die mir nicht
gefallen.  Dazu gehört z.B. das man seine minimieren/maximieren Button
wieder in der Fensterleiste hat und das Icons auf dem Desktop abgelegt
werden können.

[1] https://wiki.gnome.org/Projects/dconf/SystemAdministrators
"

    rstHeading "Einrichten des 'user' Profile für dconf" section
    echo
    TEMPLATES_InstallOrMerge "/etc/dconf/profile/user" root root 644
    echo

    rstHeading "Einstellungen zur GNOME Shell" section
    echo
    TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/00_site_settings" root root 644

    rstHeading "Einstellungen zu den GNOME Extenions" section
    echo
    TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/00_gnome_extensions" root root 644

    rstHeading "Einstellungen zum GNOME Dateiexplorer (aka. File, aka Nautilus)" section
    echo
    TEMPLATES_InstallOrMerge "/etc/dconf/db/site.d/00_nautilus_settings" root root 644
    # FIXME: ich weiß nicht warum, aber ich muss bei mir die DB erst ganz löschen
    # sonst werden ein paar Settings nicht in die DB übernommen ?!?!
    rm /etc/dconf/db/site
    dconf update

    waitKEY
}

# ----------------------------------------------------------------------------
install_gnomeShell(){
    rstHeading "GNOME Shell"
# ----------------------------------------------------------------------------

    if ! askYn "Soll die GNOME Shell installiert werden?"; then
        return 42
    fi
    TITLE="Installation GNOME Pakete" aptInstallPackages ${GNOME3_PACKAGES}

    install_gnome_extensions
    install_dconf_defaults

    rstHeading "Deinstallation Unity"

    rstBlock "Es wurde der Gnome-Shell Desktop installiert. Der Desktop Unity
Klimbim von Ubuntu ist damit nicht weiter erforderlich. Unity kann mit allen
seinen Komponenten deinstalliert werden."

    remove_unity
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
