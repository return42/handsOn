#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install some deb-packages
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

EMACS_VERSION=emacs26

# BASE_PACKAGES und DEVELOP_PACKAGES bilden eine große Schnittmenge, da die
# handsOn für z.B. die mozCloud oder den Apache Server diverse Pakete benötigen,
# die auch den "Entwicklertools" zuzuordnen sind. Die Erläuterungen zu diesen
# Paketen findet sich entsprechend in der Dokumentation zu den
# "Entwicklertools".

BASE_PACKAGES_TITLE="Basispakete zum Betrieb eines Servers"
BASE_PACKAGES="\
 util-linux ppa-purge ssh ubuntu-drivers-common \
 aptitude software-properties-common apt-file synaptic gdebi bash-completion \
 build-essential dkms tree \
 python \
 python3-dev python3-argcomplete python3-pip python3-virtualenv pylint3 \
 git curl colordiff meld \
 gparted exfat-fuse exfat-utils smartmontools \
 ncdu poppler-utils \
"

DEVELOP_PACKAGES_TITLE="Basispakete zum Kompilieren & Installieren"
DEVELOP_PACKAGES="\
 build-essential linux-headers-generic \
 autoconf autotools-dev automake libtool-bin gettext \
 shellcheck devscripts \
 dkms \
 python3-dev python3-argcomplete python3-pip python3-virtualenv pylint3 \
 git git-email git-svn \
 subversion mercurial bzr \
 diffutils colordiff patch grep \
 sqlitebrowser sqlite3 \
 docker.io \
"
# libjpeg-dev \

AUTHORING_PACKAGES="\
 texlive-base texlive-xetex texlive-latex-recommended \
 texlive-extra-utils dvipng ttf-dejavu \
 graphviz \
"

BASE_DOC_PACKAGES="\
 debian-handbook libpam-doc \
"
OFFICE_PACKAGES_TITLE="Pakete für Desktop & Office"
OFFICE_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/office.html"

OFFICE_PACKAGES="\
 libreoffice libreoffice-l10n-de libreoffice-help-de libreoffice-gtk libreoffice-style-sifr \
 firefox \
 thunderbird \
 hunspell hunspell-de-de \
 mupdf qpdfview \
"
# Remote Desktop (Server)
# RDP_PACKAGES="\
#  freerdp-x11 \
# "

MULTIMEDIA_CLIENT_PACKAGES_TITLE="MultiMedia Pakete, Video, Audio"
MULTIMEDIA_CLIENT_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/multimedia.html"
MULTIMEDIA_CLIENT_PACKAGES="\
 vlc qmmp openshot handbrake mixxx audacious mpv
"
CODEC_PACKAGES_TITLE="Codec Pakete; Audio & Video Tools"
CODEC_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/codecs.html"
CODEC_PACKAGES="\
 ffmpeg libavcodec-extra
 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
"
# gstreamer1.0-plugins-ugly

IMAGE_TOOLS_PACKAGES_TITLE="Tools zur Bildbearbeitung / -Betrachtung"
IMAGE_TOOLS_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/imgTools.html"
IMAGE_TOOLS_PACKAGES="\
 gimp gimp-plugin-registry gimp-data-extras gimp-help-de \
 cheese \
 darktable \
 rawtherapee \
 pinta \
 gnome-photos \
 inkscape \
"

ARCHIVE_TOOLS_PACKAGES_TITLE="Tools zur Archivierung und Komprimierung"
ARCHIVE_TOOLS_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/archTools.html"
ARCHIVE_TOOLS_PACKAGES="\
 tar gzip unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller \
"

HARDWARE_PACKAGES_TITLE="Hardware-Tools"
HARDWARE_PACKAGES="\
 powertop lm-sensors psensor pm-utils exfat-fuse exfat-utils \
"

MONITORING_PACKAGES_TITLE="System-Monitoring-Tools"
MONITORING_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/monitoring.html"
MONITORING_PACKAGES="\
 htop \
 lm-sensors \
 iotop \
 fatrace \
"

#* dhcpcd(8) :  DHCP and DHCPv6 client. It's also an IPv4LL (aka ZeroConf) client
#               http://roy.marples.name/projects/dhcpcd
NETWORK_PACKAGES_TITLE="Network-Tools"
NETWORK_PACKAGES_DOC="http://return42.github.io/handsOn/ubuntu_install_pkgs/netTools.html"

NETWORK_PACKAGES="\
 wireshark libwireshark-data wireshark-doc \
 iptraf \
 nmap \
"

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
        usage|-h|--help) usage;;
        bootstrap)    install_bootstrap;;

        all)
            FORCE_TIMEOUT=2
            install_base
            install_develop
            install_office
            install_multimedia
            install_codecs
            install_imgTools
            install_archTools
            install_hwTools
            install_monitoring
            install_netTools
            install_remmina
            ;;
	base)         install_base;;
        develop)      install_develop;;
        office)       install_office;;
        multimedia)   install_multimedia;;
        codecs)       install_codecs;;
        imgTools)     install_imgTools;;
        archTools)    install_archTools;;
        hwTools)      install_hwTools;;
        monitoring)   install_monitoring;;
        netTools)     install_netTools;;
        remmina)      install_remmina;;
        timeshift)    install_timeshift;;
        ukuu)         install_ukuu;;
        flatpak)      install_flatpak;;
        *)
            usage "${BRed}ERROR:${_color_Off} unknown or missing command"
            exit 42
            ;;
    esac
    #apt-get -y autoremove
}


# ----------------------------------------------------------------------------
usage(){
# ----------------------------------------------------------------------------

    [[ ! -z ${1+x} ]] &&  echo -e "\n$1"
    cat <<EOF
usage:
  $(basename $0) [all|<install-bundle>]

Alias 'all' umfasst folgende <install-bundle>

- base:       ${BASE_PACKAGES_TITLE}
- develop:    ${DEVELOP_PACKAGES_TITLE}
- office:     ${OFFICE_PACKAGES_TITLE}
- multimedia: ${MULTIMEDIA_CLIENT_PACKAGES_TITLE}
- codecs:     ${CODEC_PACKAGES_TITLE}
- imgTools:   ${IMAGE_TOOLS_PACKAGES_TITLE}
- archTools:  ${ARCHIVE_TOOLS_PACKAGES_TITLE}
- hwTools:    ${HARDWARE_PACKAGES_TITLE}
- monitoring: ${MONITORING_PACKAGES_TITLE}
- netTools:   ${NETWORK_PACKAGES_TITLE}
- remmina:    RDP-Client

Ansonsten stehen noch zur Verfügung:

- timeshift:  Timeshift (backup)
- ukuu:       Ubuntu Kernel Upgrade Utility

EOF
}

# ----------------------------------------------------------------------------
install_bootstrap(){
    rstHeading "Installation erforderlicher Pakete"
# ----------------------------------------------------------------------------

    rstPkgList ${BASE_PACKAGES}
    echo
    apt-get install -y ${BASE_PACKAGES}
    echo
    info_msg "Installation der handsOn abgeschlossen"
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_base(){
    rstHeading "${BASE_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------

    aptInstallPackages ${BASE_PACKAGES}

    rstHeading "Aktualisiere PCI-IDs (für lspci)" section
    echo
    update-pciids

    rstHeading "Default Einstellungen für Synaptic" section
    mkdir -p /root/.synaptic
    TEMPLATES_InstallOrMerge /root/.synaptic/synaptic.conf root root 644

    rstHeading "Installation verschiedener Dokumentationen"
    aptInstallPackages ${BASE_DOC_PACKAGES}
}

# ----------------------------------------------------------------------------
install_develop(){
    rstHeading "${DEVELOP_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------

    # .. _`Standard C Library`: http://www.gnu.org/software/libc/
    # .. _`GNU Compiler Collection`: https://gcc.gnu.org/
    # .. _`DB Browser für SQLite`: http://sqlitebrowser.org/
    # .. _`SQLite`: https://www.sqlite.org/
    # .. _`The GNU Portable Library Tool`: http://www.gnu.org/software/libtool/

    echo -e "
Es werden Entwickler Tools installiert, dazu gehören unter anderem:

* build-essential: Beinhaltet die *GNU Compiler Collection* und die *Standard C
  Library*.

* sqlitebrowser, sqlite3: *SQLite* inkl. Komandozeile und ein *DB Browser für
  SQLite*.

* docker: Vereinfacht die Bereitstellung von Anwendungen in Containern. Damit
  ein Benutzer Docker verwenden kann, muss er der Gruppe 'docker' hinzgefügt
  werden.

* TeX Live: Eine LaTeX Installation (https://www.tug.org/texlive/)

* graphviz: Ein Visualisierungs Werkzeug (http://graphviz.org/)
"

    aptInstallPackages ${DEVELOP_PACKAGES} ${AUTHORING_PACKAGES}
    installEmacsStable

    rstBlock "Pfade in denen Bibliotheken zu finden sind ..."
    TEE_stderr <<EOF| bash | prefix_stdout
    ldconfig -v 2> /dev/null | grep "^/"
EOF
    # if ! grep -q "/usr/local/lib" /etc/ld.so.conf; then

    # rstBlock "Viele Build-Prozesse installieren ihre Bibliotheken in den
    #   Ordner ``/usr/local/lib/``. Dieser Pfad ist derzeit nicht in den Such-Pfaden
    #   enthalten, in denen nach Bibliotheken gesucht wird."

    # if askYn "Soll der Pfad als Such-Pfad eingetragen werden?"; then
    #     echo "/usr/local/lib" >> /etc/ld.so.conf
    #     ldconfig
    # fi
    # fi
    waitKEY 30
}

# ----------------------------------------------------------------------------
installEmacsStable() {
    rstHeading "Emacs" section
# ----------------------------------------------------------------------------

    local PPA="ppa:kelleyk/emacs"
    rstBlock "Alte Emacs Installationen werden deinstalliert"
    apt purge -y "emacs*"
    apt autoremove -y
    rstBlock "Aktuelle Emacs Version (${EMACS_VERSION}) wird aus $PPA bezogen .."
    add-apt-repository -y $PPA
    apt-get update
    apt-get install ${EMACS_VERSION} ${EMACS_VERSION}-el aspell-de aspell-en
    update-alternatives --set emacs /usr/bin/${EMACS_VERSION}
    waitKEY 30
}


# ----------------------------------------------------------------------------
install_office(){
    rstHeading "${OFFICE_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------
    rstBlock "${OFFICE_PACKAGES_DOC}"
    aptInstallPackages ${OFFICE_PACKAGES}
}

# ----------------------------------------------------------------------------
install_multimedia(){
    rstHeading "${MULTIMEDIA_CLIENT_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------
    rstBlock "${MULTIMEDIA_CLIENT_PACKAGES_DOC}"
    aptInstallPackages ${MULTIMEDIA_CLIENT_PACKAGES}
}

# ----------------------------------------------------------------------------
install_codecs(){
    rstHeading "${CODEC_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------
    rstBlock "${CODEC_PACKAGES_DOC}"
    aptInstallPackages ${CODEC_PACKAGES}
    TITLE="Sollen die ubuntu-restricted-extras installiert werden?"\
         aptInstallPackages ubuntu-restricted-extras
}

# ----------------------------------------------------------------------------
install_imgTools(){
    rstHeading "${IMAGE_TOOLS_PACKAGES_TITLE}" part
# ----------------------------------------------------------------------------
    rstBlock "${IMAGE_TOOLS_PACKAGES_DOC}"
    aptInstallPackages ${IMAGE_TOOLS_PACKAGES}
}

# ----------------------------------------------------------------------------
install_archTools(){
    rstHeading "${ARCHIVE_TOOLS_PACKAGES_TITLE}"  part
# ----------------------------------------------------------------------------
    rstBlock "${ARCHIVE_TOOLS_PACKAGES_DOC}"
    aptInstallPackages ${ARCHIVE_TOOLS_PACKAGES}
}

# ----------------------------------------------------------------------------
install_hwTools(){
    rstHeading "${HARDWARE_PACKAGES_TITLE}"
# ----------------------------------------------------------------------------

    echo -e "
Zu den *Hardware-Tools* zählen:

* powertop(8) zur Bewertung des Stromverbrachs von Programmen
* pm-suspend(8), pm-hibernate(8) etc.  für die Power-Save Modi
* psensor(1) für die Temparaturüberwachung
* exFAT ein Dateisystem das häufig auf SD-Karten verwendet wird
"
    aptInstallPackages ${HARDWARE_PACKAGES}

    rstBlock "${BYellow}\
Folgend müssen Sie kurz die Hardware-Scans des lm-sensor Pakets bestätigen. Im
Zweifelsfall reicht es aus, einfach ENTER zu drücken. Lediglich bei der letzten
Frage sollten Sie beachten, dass die erforderlichen Kernel-Module eingetragen
werden.${_color_Off}
"
    sensors-detect
    service kmod start
    sensors

    rstBlock "${BYellow}\
Zur Senosrauswertung kann *psensors* gestartet werden. Für die Gnome-Shell
kann die Erweiterung

  https://extensions.gnome.org/extension/120/system-monitor/

installiert werden.

Folgende Energiesparmodie werden unterstützt: ${_color_Off}
"

    for i in --suspend --hibernate --suspend-hybrid; do
	pm-is-supported $i && echo "$(echo " * $i" | tr [:lower:] [:upper:] | tr -d -) is supported";
    done;
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_monitoring(){
    rstHeading "${MONITORING_PACKAGES_TITLE}"  part
# ----------------------------------------------------------------------------
    rstBlock "${MONITORING_PACKAGES_DOC}"
    aptInstallPackages ${MONITORING_PACKAGES}
}

# ----------------------------------------------------------------------------
install_netTools(){
    rstHeading "${NETWORK_PACKAGES_TITLE}"  part
# ----------------------------------------------------------------------------
    rstBlock "${NETWORK_PACKAGES_DOC}"
    aptInstallPackages ${NETWORK_PACKAGES}
}

# ----------------------------------------------------------------------------
install_remmina(){
    rstHeading "Installation Remmina RDP-Client"
# ----------------------------------------------------------------------------

    # siehe https://bugs.launchpad.net/ubuntu/+source/remmina/+bug/1439478/comments/22
    REMMINA_PPA="ppa:remmina-ppa-team/remmina-next"
    REMMINA_SOURCE_NAME="remmina"

    rstBlock "Die Ubuntu Pakete zum Remmina sind schlecht gepflegt,
deshalb wird Remmina aus dem PPA $REMMINA_PPA installiert."
    if ! askYn "soll der Remmina RDP-Client installiert werden?" 60; then
        return 42
    fi

    add-apt-repository "$REMMINA_PPA"

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    apt-get install remmina
    waitKEY
}

# ----------------------------------------------------------------------------
install_timeshift(){
    rstHeading "Installation Timeshift (backup)"
# ----------------------------------------------------------------------------

    # siehe https://medium.com/@teejeetech/timeshift-v18-2-843bb4d39dfd
    TIMESHIFT_PPA="ppa:teejee2008/ppa"

    rstBlock "Die Ubuntu Pakete zum Timeshift sind schlecht gepflegt,
deshalb wird Timeshift aus dem PPA $TIMESHIFT_PPA installiert."
    if ! askYn "soll das Backup-Tool Timeshift installiert werden?" 60; then
        return 42
    fi

    add-apt-repository "$TIMESHIFT_PPA"

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    apt-get install timeshift
    waitKEY
}

# ----------------------------------------------------------------------------
install_ukuu(){
    rstHeading "Installation Ukuu"
# ----------------------------------------------------------------------------

    local _repo=https://github.com/return42/ukuu
    local _ws="${CACHE}/ukuu"

    rstBlock "Ukuu wird aus dem Reposetory $_repo installiert."
    if ! askYn "soll das Kernel-Tool Ukuu installiert werden?" 60; then
        return 42
    fi

    apt-get install libgee-0.8-dev libjson-glib-dev libvte-2.91-dev valac

    cloneGitRepository "$_repo" ukuu

    rstBlock "run make ..."
    pushd "$_ws" > /dev/null
    if [[ ! -z ${SUDO_USER} ]]; then
        sudo -u ${SUDO_USER} make all | prefix_stdout
    else
       make all | prefix_stdout
    fi

    TEE_stderr 1 <<EOF | bash | prefix_stdout
make install
EOF
    popd > /dev/null
    waitKEY
}

# ----------------------------------------------------------------------------
install_flatpak(){
    rstHeading "Installation Flatpak"
# ----------------------------------------------------------------------------

    # siehe https://flatpak.org/setup/Ubuntu/
    PPA="ppa:alexlarsson/flatpak"

    rstBlock "Flatpack wird aus dem PPA $PPA installiert."
    if ! askYn "soll das Flatpack installiert werden?" 60; then
        return 42
    fi

    add-apt-repository "$PPA"

    rstHeading "Katalog aktualisieren" section
    echo
    apt-get update
    apt-get install flatpak
    waitKEY

    apt install gnome-software-plugin-flatpak

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
