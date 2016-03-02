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

BASE_PACKAGES="\
 util-linux ppa-purge ssh \
 aptitude synaptic gdebi \
 build-essential dkms tree \
 python-dev python-argcomplete python-pip python-virtualenv pylint \
 git subversion mercurial bzr \
 emacs curl colordiff \
 gparted usbmount exfat-fuse exfat-utils smartmontools \
"

BASE_DOC_PACKAGES="\
 libpam-doc \
"

OFFICE_PACKAGES="\
 libreoffice libreoffice-l10n-de libreoffice-help-de libreoffice-gtk libreoffice-style-sifr \
 firefox \
 thunderbird \
 hunspell hunspell-de-de \
"
# Remote Desktop (Server)
# RDP_PACKAGES="\
#  freerdp-x11 \
#  remmina \
# "

MULTIMEDIA_CLIENT_PACKAGES="\
 vlc qmmp openshot handbrake mixxx audacious mpv
"

CODEC_PACKAGES="\
 libav-tools libavcodec-extra \
 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
"
# gstreamer1.0-plugins-ugly

IMAGE_TOOLS_PACKAGES="\
 gimp gimp-plugin-registry gimp-data-extras gimp-help-de \
 cheese \
 darktable \
 rawtherapee \
 pinta \
 shotwell \
 inkscape \
"

ARCHIVE_TOOLS_PACKAGES="\
 tar gzip unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller \
"

HARDWARE_PACKAGES="\
 powertop lm-sensors psensor pm-utils \
"

MONITORING_PACKAGES="\
 htop \
 glances lm-sensors \
 iotop \
"

DEVELOP_PACKAGES="\
 devscripts build-essential linux-headers-generic \
 autotools-dev autoconf \
 gettext libtool \
 libjpeg-dev \
 sqlitebrowser sqlite3 \
"

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
	base)
            install_basePackages
            install_baseDoc
	    ;;
        devTools)
            install_devPackages
            ;;
        office)
            install_Office
            ;;
        multimedia)
            install_MultiMedia
            ;;
        codecs)
            install_Codecs
            ;;
        imgTools)
            install_ImageTools
            ;;
        archTools)
            install_ArchiveTools
            ;;
        hwTools)
            install_HardwareTools
            ;;
        monitoring)
            install_MonitoringTools
            ;;
        netTools)
            install_NetworkTools
            ;;
        *)
            echo
	    echo "usage $0 [base|devTools|office|multimedia|codecs|imgTools|archTools|hwTools|monitoring|netTools]"
            echo
            ;;
    esac
    #apt-get -y autoremove
}

# ----------------------------------------------------------------------------
install_basePackages(){
    rstHeading "Installation der Basis-Pakete"
# ----------------------------------------------------------------------------

    rstPkgList ${BASE_PACKAGES}
    waitKEY 30
    echo
    apt-get install -y ${BASE_PACKAGES}
    waitKEY 30

    rstHeading "Default Einstellungen für Synaptic" section
    TEMPLATES_InstallOrMerge /root/.synaptic/synaptic.conf root root 644
}

# ----------------------------------------------------------------------------
install_baseDoc(){
    rstHeading "Installation verschiedener Dokumentationen"
# ----------------------------------------------------------------------------

    rstPkgList ${BASE_DOC_PACKAGES}
    waitKEY 30
    echo
    apt-get install -y ${BASE_DOC_PACKAGES}
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_devPackages(){
    rstHeading "Entwickler Pakete"
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
"

    rstPkgList ${DEVELOP_PACKAGES}
    if ! askYn "sollen die Entwickler Pakete installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${DEVELOP_PACKAGES}
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
install_Office(){
    rstHeading "Office"
# ----------------------------------------------------------------------------

    rstPkgList ${OFFICE_PACKAGES}
    if ! askYn "Sollen die Office-Pakete installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${OFFICE_PACKAGES}
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_MultiMedia(){
    rstHeading "MultiMedia Pakete"
# ----------------------------------------------------------------------------

    echo -e "
Es werden verschiedene (Client) Multimedia Pakete installiert:

* vlc:       Videoplayer                http://www.videolan.org/
* handbrake: Videokonvertierung         https://handbrake.fr/
* openshot:  Videoeditor                http://openshot.org/
* qmmp:      Qt Mediaplayer             http://qmmp.ylsoftware.com/
* mixxx:     Disk Jokey Mix Software    http://mixxx.org/
* audacious: Audioplayer (winamp like)  http://audacious-media-player.org/"

    rstPkgList ${MULTIMEDIA_CLIENT_PACKAGES}
    if ! askYn "sollen die Multimedia Pakete installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${MULTIMEDIA_CLIENT_PACKAGES}
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_Codecs(){
    rstHeading "Codecs"
# ----------------------------------------------------------------------------

    rstPkgList ${CODEC_PACKAGES}
    if ! askYn "Sollen Pakete für erweiterte Codecs installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${CODEC_PACKAGES}
    waitKEY 30
}


# ----------------------------------------------------------------------------
install_ImageTools(){
    rstHeading "Tools zur Bildbearbeitung / -Betrachtung"
# ----------------------------------------------------------------------------

    echo -e "
Es werden verschiedene Tools zur Bildbearbeitung installiert:

* gimp        High-End 2D *pixel-based* Bildbearbeitung
              http://www.gimp.org/

  - gimp-data-extras zusätzliche Pinsel, Paletten und Gradienten
  - gimp-plugin-registry Depot mit optionalen Erweiterungen für GIMP

* cheese      Aufnahmen mit der *Webcam*
              https://wiki.gnome.org/Apps/Cheese

* pinta       Einfaches 2D *pixel-based* Zeichenprogramm
              http://pinta-project.com/

* inkscape    Einfaches Tool zur 2D *vector-based* Grafikbearbeitung
              https://inkscape.org/de/

* darktable   Software zur Aufbereitung und Verwaltung von Digitalfotos
              http://www.darktable.org/

* rawtherapee RawTherapee ist ein RAW-Konverter zur Umwandlung und Bearbeitung
              von fotografischen Rohdaten von Digitalkameras in gängige
              Bildformate.
              http://rawtherapee.com/blog/screenshots

* shotwell    Bildverwaltung
              https://wiki.gnome.org/Apps/Shotwell/

.. hint::

  Man könnte noch digikam als etwas aufwendigere Alternative zu shotwell
  installiern.  "

    rstPkgList ${IMAGE_TOOLS_PACKAGES}
    if ! askYn "sollen die Pakete installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${IMAGE_TOOLS_PACKAGES}
    waitKEY 30
}

# ----------------------------------------------------------------------------
install_ArchiveTools(){
    rstHeading "Tools zur Archivierung und Komprimierung"
# ----------------------------------------------------------------------------

    rstBlock "Es werden verschiedene Tools zum Packen und Entpacken von Dateien
installiert: "

    rstPkgList ${ARCHIVE_TOOLS_PACKAGES}
    if ! askYn "sollen die Pakete installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${ARCHIVE_TOOLS_PACKAGES}
    waitKEY 30

}

# ----------------------------------------------------------------------------
install_HardwareTools(){
    rstHeading "Hardware-Tools"
# ----------------------------------------------------------------------------

    echo -e "Zu den *Hardware-Tools* zählen:

* powertop(8) zur Bewertung des Stromverbrachs von Programmen
* pm-suspend(8), pm-hibernate(8) etc.  für die Power-Save Modi
* psensor(1) für die Temparaturüberwachung
"
    rstPkgList ${HARDWARE_PACKAGES}
    if ! askNy "Sollen die Hardware Tools installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${HARDWARE_PACKAGES}

    rstBlock "${BYellow}\
Folgend müssen Sie kurz die Hardware-Scans des lm-sensor Pakets bestätigen. Im
Zweifelsfal reicht es einfach ENTER zu drücken. Lediglich bei der letzten Frage
sollten Sie beachten, dass die erforderlichen Kernel-Module eingetragen
werden.${_color_Off}
"
    sensors-detect
    service kmod start
    sensors

    rstBlock "${BYellow}\
Zur Senosrauswertung kann *psensors* gestartet werden oder Für die Gnome-Shell
kann die Erweiterung https://extensions.gnome.org/extension/120/system-monitor/
instaliert werden.

Folgende Energiesparmodie werden unterstützt: ${_color_Off}
"

    for i in --suspend --hibernate --suspend-hybrid; do
	pm-is-supported $i && echo "$(echo " * $i" | tr [:lower:] [:upper:] | tr -d -) is supported";
    done;
    waitKEY 30
}


# ----------------------------------------------------------------------------
install_MonitoringTools(){
    rstHeading "Monitoring-Tools"
# ----------------------------------------------------------------------------

    echo -e "
Zu den System *Monitoring-Tools* zählen:

* htop(8) : das *schönere* ``top`` http://hisham.hm/htop/
* glances : noch *schöneres* curses-based system monitoring tool
            *  http://nicolargo.github.io/glances/
            * http://glances.readthedocs.org/en/latest/glances-doc.html
            FIXME: die Sensoren bekomme ich noch nciht zur Ansicht"

    rstPkgList ${MONITORING_PACKAGES}
    if ! askNy "Sollen die Tools installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${MONITORING_PACKAGES}

    waitKEY 30
}

# ----------------------------------------------------------------------------
install_NetworkTools(){
    rstHeading "Network-Tools"
# ----------------------------------------------------------------------------
#* dhcpcd(8) :  DHCP and DHCPv6 client. It's also an IPv4LL (aka ZeroConf) client
#               http://roy.marples.name/projects/dhcpcd

    NETWORK_PACKAGES="\
 wireshark libwireshark-data wireshark-doc \
 iptraf \
 nmap \
"
    echo -e "
Zu den *Network-Tools* zählen:

* wireshark :  Netzwerk Protokoll Analyzer
               https://www.wireshark.org/
* nmap      :  Portscanner
               https://nmap.org/
* iptraf    :  console-based network monitoring
               http://iptraf.seul.org/"

    rstPkgList ${NETWORK_PACKAGES}
    if ! askNy "Sollen die Tools installiert werden?" 10; then
        return 42
    fi
    echo
    apt-get install -y ${NETWORK_PACKAGES}

    waitKEY 30
}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
