#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install VirtualBox
# ----------------------------------------------------------------------------

# MEMO:
#
# Der /home/vbox Ordner sollte via symbolischen Link auf eine andere Platte
# verschoben werden.
#
# Remote virtual machines
# -----------------------
#
# siehe https://www.virtualbox.org/manual/ch07.html
#
# Der RDP-Client rdesktop-vrdp wird mit VirtualBox bereits installiert. Mit
# diesem Client kann man auch remote USB machen.
#
# Die "RDP authentication" kann für jeden Gast eingestellt werden, sie sollte
# auf 'default' stehen, damit die Accounts des HOST Systems verwendet werden.
#
# Um das VirtualBox des 'vbox' zu Verwalten stelle ich vom Client eine ssh
# Verbindung mit X-Forwarding zum Remote-HOST System her und rufe dort die
# Interaktive Oberfläche auf::
#
#    client$ ssh -X vbox@kaveri
#    kaveri$ VirtualBox
#
# Eine Alternative könnte evtl. RemoteBox (http://knobgoblin.org.uk) bei
# aktivierten vboxweb-service sein. Das hab ich aber nicht genutzt, da ich
# obiges wesentlich einfacher finde. Eine Alternative zu RemoteBox mag
# phpVirtualBox sein.

source $(dirname ${BASH_SOURCE[0]})/setup.sh

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

export SYSTEMD_PAGER=cat

# Oracle Downloads
ORACLE_VBOX_DOWNLOAD_URL="http://download.virtualbox.org/virtualbox"
ORACLE_VBOX_LATEST="$(curl ${ORACLE_VBOX_DOWNLOAD_URL}/LATEST.TXT 2> /dev/null)"
ORACLE_VBOX_LATEST_URL="${ORACLE_VBOX_DOWNLOAD_URL}/${ORACLE_VBOX_LATEST}"

ORACLE_VBOX_EXTPACK_NAME="Oracle VM VirtualBox Extension Pack"
ORACLE_VBOX_EXTPACK_URL="${ORACLE_VBOX_LATEST_URL}/Oracle_VM_VirtualBox_Extension_Pack-${ORACLE_VBOX_LATEST}.vbox-extpack"

ORACLE_VBOX_GUEST_ADDONS_ISO="VBoxGuestAdditions_${ORACLE_VBOX_LATEST}.iso"
ORACLE_VBOX_GUEST_ADDONS_URL="${ORACLE_VBOX_LATEST_URL}/${ORACLE_VBOX_GUEST_ADDONS_IDO}"

# Paketverwaltung
ORACLE_VBOX_APT="oracle-vbox"
ORACLE_VBOX_VERS="$(echo "$ORACLE_VBOX_LATEST" | cut -d. -f1-2)"
ORACLE_VBOX_PACKAGE="virtualbox-$ORACLE_VBOX_VERS"

# APT
ORACLE_VBOX_PKEY_URL="https://www.virtualbox.org/download/oracle_vbox_2016.asc"
ORACLE_VBOX_APT_DEB="http://download.virtualbox.org/virtualbox/debian"

# Gruppe der Benutzer, die VirtualBox benutzen dürfen
VBOXUSERS_GROUP=vboxusers

# Der Account unter dem die Headless-Server laufen
VBOX_GROUP=vbox
VBOX_USER=vbox

# Setup der VirtualBox Suite
VBOX_SETUP=/etc/default/virtualbox
VBOXAUTOSTART_DB=/etc/vbox/autostart.db
VBOXAUTOSTART_CONFIG=/etc/vbox/autostart.cfg


# ----------------------------------------------------------------------------
main(){
    rstHeading "VirtualBox" part
# ----------------------------------------------------------------------------

    case $1 in
	install)
            sudoOrExit
            install_vbox
            vbox_services status
	    ;;
	update)
            sudoOrExit
            install_vbox_deb
            if askYn "Soll das VBox Extension Pack installiert werden (PUEL)?"; then
	        installExtensionPack
            fi
            vbox_services status
	    ;;
	deinstall)
            sudoOrExit
            deinstall_vbox
	    ;;
        README)
            rstHeading "README"
            README_VBOX
            ;;
	*)
            echo
	    echo "usage $0 [(de)install|README]"
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
README_VBOX(){
# ----------------------------------------------------------------------------

    rstHeading "Setup der VirtualBox Suite" section
    echo -e "
* Konfiguration: ${VBOX_SETUP}
* Autostart Datenbank: ${VBOXAUTOSTART_DB}
* Autostart Konfiguration: ${VBOXAUTOSTART_CONFIG}
* Gruppe der VirtualBox Benutzer: ${VBOXUSERS_GROUP}
* Benutzer:Gruppe der Headless-Server: ${VBOX_USER}:${VBOX_GROUP}
"

    rstHeading "Quellen" section
    echo -e "
* APT-Source: ${ORACLE_VBOX_APT_DEB}
* APT-Packages: ${ORACLE_VBOX_PACKAGE}
* Extension-Pack Ver.: ${ORACLE_VBOX_LATEST}
  ${ORACLE_VBOX_EXTPACK_URL}
* Guest-Addons Ver.: ${ORACLE_VBOX_LATEST}
  ${ORACLE_VBOX_GUEST_ADDONS_URL}
"
    vbox_services status
}


# ----------------------------------------------------------------------------
vbox_services(){
    rstHeading "VirtualBox Dienste ($1)" section
# ----------------------------------------------------------------------------
    echo
    TEE_stderr 0.5 <<EOF | bash
systemctl $1 vboxballoonctrl-service.service

systemctl $1 vboxdrv.service

systemctl $1 vboxweb-service.service

systemctl $1 vboxautostart-service.service

EOF
    waitKEY
}

# ----------------------------------------------------------------------------
install_vbox(){
    rstHeading "Installation VirtualBox"
# ----------------------------------------------------------------------------

    rstBlock "Im ersten Schritt werden einige Voraussetzungen installiert, erst
danach erfolgt die Installation des VirtualBox ${ORACLE_VBOX_VERS}."

    if ! askYn "Soll ${BYellow}VirtualBox ${ORACLE_VBOX_VERS}${_color_Off} installiert werden?"; then
        return 42
    fi

    useradd_vbox
    install_setup
    installAutostartDB
    install_vbox_deb

    if askYn "Soll das VBox Extension Pack installiert werden (PUEL)?"; then
	installExtensionPack
    fi
    customize_vbox
}


# ----------------------------------------------------------------------------
customize_vbox(){
    rstHeading "VirtualBox (XML) Setup für Benutzer ${VBOX_USER}"
# ----------------------------------------------------------------------------

    rstBlock "Eigentlich braucht man folgendes nicht expliziet zu setzen, aber
es veranschaulicht nochmal, dass die VBox Settings dem ${VBOX_USER} gehören"

    echo
    TEE_stderr <<EOF | bash | prefix_stdout
sudo -u ${VBOX_USER} --set-home VBoxManage setproperty websrvauthlibrary default
sudo -u ${VBOX_USER} --set-home VBoxManage setproperty vrdeauthlibrary default
sudo -u ${VBOX_USER} --set-home VBoxManage setextradata global GUI/MaxGuestResolution any
EOF
    waitKEY
    rstHeading "Neustart des vboxweb-service" section
    echo
    # FIXME: der restart hat bei mir manchmal nicht geklappt, ich nehme an, das
    # es ein Zeit-Problem ist und zw. dem stop und dem sart etwas gewartet
    # werden muss.
    TEE_stderr 5 <<EOF | bash
systemctl stop vboxweb-service
systemctl start vboxweb-service
systemctl status vboxweb-service
EOF
    waitKEY
}

# ----------------------------------------------------------------------------
deinstall_vbox(){
    rstHeading "De-Installation VirtualBox"
# ----------------------------------------------------------------------------

    rstBlock "${BRed}ACHTUNG:${_color_Off}

    Folgende Aktion löscht die VirtualBox samt Konfiguration!"

    if ! askNy "Wollen sie WIRKLICH VirtualBox löschen?"; then
        return 42
    fi

    deinstallExtensionPack
    # aptPurgePackages ${ORACLE_VBOX_PACKAGE}

    # FIXME:
    #
    # Ich hatte Probleme mit der 5.1.20 Version, diese lies sich nur manuell::
    #
    #   sudo apt-get remove virtualbox-5.1
    #
    # deinstallieren. Hier im Script kam aus unerklärlichen Gründen immer die
    # Meldung, dass angeblich noch ein VBoxSVC Dienst noch laufen würde (was aber
    # nicht der Fall ist)."

    echo
    apt-get remove  ${ORACLE_VBOX_PACKAGE}

    # Vermutlich liegt das an der Funktion check_running aus der Datei
    # /usr/lib/virtualbox/routines.sh. Diese Funktion wird während der
    # De-Installation von dem Skript /usr/lib/virtualbox/prerm-common.sh
    # aufgerufen und liefert häufig (nicht immer) einen exit-code 1. Erweckt
    # also den Anschein, als würde hier noch ein Dienst laufen.

    waitKEY

    rstHeading "Repository entfernen" section
    echo
    aptRemoveRepository ${ORACLE_VBOX_APT}

    rstHeading "Löschen der Gruppe ${VBOXUSERS_GROUP}" section
    echo
    TEE_stderr <<EOF | bash | prefix_stdout
    delgroup ${VBOXUSERS_GROUP}
EOF
    waitKEY

    remove_setup
    userdel_vbox
}

# ----------------------------------------------------------------------------
useradd_vbox(){
    rstHeading "Einrichten des ${VBOX_USER} Benutzers" section
# ----------------------------------------------------------------------------

    rstBlock "Der Benutzer ${VBOX_USER} wird eingerichtet. Er verwaltet die GAST
Systeme, die *Headless* bereit gestellt werden. Unter diesem Account laufen auch
die Dienste wie z.B. vboxweb-service oder watchdog, siehe VBOXWEB_USER und
VBOXWATCHDOG_USER in ${VBOX_SETUP}."

    echo -e "
Für diese Aufgaben muss der Benutzer verschiedenen Gruppen hinzugefügt werden:

* ${VBOXUSERS_GROUP}: um VirtualBox nutzen zu können
* ssl-cert: für den Zugriff auf den privaten Schlüssel
  siehe VBOXWEB_SSL_KEYFILE
* syslog zum Anlegen der LOG-Files
"
    adduser --gecos "" ${VBOX_USER}

    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
addgroup --system ${VBOXUSERS_GROUP}
usermod -a -G ${VBOXUSERS_GROUP}  ${VBOX_USER}
usermod -a -G ssl-cert ${VBOX_USER}
usermod -a -G syslog ${VBOX_USER}
EOF

    waitKEY
}

# ----------------------------------------------------------------------------
userdel_vbox(){
    rstHeading "Löschen des ${VBOX_USER} Benutzers" section
# ----------------------------------------------------------------------------

    if ! askNy "Wollen sie WIRKLICH den User ${VBOX_USER} löschen?"; then
        return 42
    fi
    TEE_stderr <<EOF | bash | prefix_stdout
    deluser ${VBOX_USER}
EOF

    rstBlock "Der HOME-Ordner wurden nicht gelöscht:"
    echo
    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
ls -la /home/${VBOX_USER}
EOF
    waitKEY
}


# ----------------------------------------------------------------------------
remove_setup(){
    rstHeading "Löschen des Setups der VirtualBox Suite " section
# ----------------------------------------------------------------------------

    rstBlock "Es existieren ggf. noch folgende Setups für VirtualBox"
    echo
    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
ls -la ${VBOX_SETUP}
ls -la ${VBOXAUTOSTART_DB}
ls -la ${VBOXAUTOSTART_CONFIG}
EOF

    if askNy "Sollen die Setups jetzt gelöscht werden?"; then
        rm ${VBOX_SETUP}
        rm -r ${VBOXAUTOSTART_DB}
        rm ${VBOXAUTOSTART_CONFIG}
        rstBlock "Setup wurde gelöscht"
    fi
    waitKEY
}



# ----------------------------------------------------------------------------
install_setup(){
    rstHeading "VirtualBox Setup" section
# ----------------------------------------------------------------------------

    rstBlock "Das Setup der VirtualBox Suite befindet sich in der Datei:

  ${VBOX_SETUP}

Bezüglich der Einstellungen, siehe Kommentare in dieser Datei, die nun
installiert wird."

    TEMPLATES_InstallOrMerge ${VBOX_SETUP} root root 644
    waitKEY
}

# ----------------------------------------------------------------------------
installAutostartDB() {
    rstHeading "Einrichten der Autostart-DB" section
# ----------------------------------------------------------------------------
    echo
    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
mkdir -p ${VBOXAUTOSTART_DB}
chown root:${VBOXUSERS_GROUP} ${VBOXAUTOSTART_DB}
chmod ug+rw ${VBOXAUTOSTART_DB}
chmod +s ${VBOXAUTOSTART_DB}
EOF
    TEMPLATES_InstallOrMerge ${VBOXAUTOSTART_CONFIG} root root 644
    waitKEY
}

# ----------------------------------------------------------------------------
install_vbox_deb(){
# ----------------------------------------------------------------------------

    rstHeading "Installation der deb-Pakete" section

    rstBlock "Die Installation aus den Oracle Paketquellen ist unter:

* https://www.virtualbox.org/wiki/Linux_Downloads

beschrieben. Es wird die aktuelle Version ${BYellow}VirtualBox
${ORACLE_VBOX_VERS}${_color_Off} installiert."

    rstHeading "Repository einrichten" section
    echo
    aptAddRepositoryURL $ORACLE_VBOX_APT_DEB $ORACLE_VBOX_APT

    rstHeading "Public-Key für das Repository einrichten" section
    echo
    aptAddPkeyFromURL $ORACLE_VBOX_PKEY_URL $ORACLE_VBOX_APT
    waitKEY

    rstHeading "Installation der Pakete" section
    rstPkgList ${ORACLE_VBOX_PACKAGE} dkms
    rstBlock "Das dkms Paket kommt nicht aus dem Oracle Reposetory, es wird aber
benötigt um die VBox-Kernel-Module nach einem Kernel-Update neu zu bauen."
    echo

    waitKEY
    apt-get update
    apt-get install -y ${ORACLE_VBOX_PACKAGE} dkms
    waitKEY

    rstBlock "Die installierte Doku befindet sich in der Datei :

  file:/usr/share/doc/${ORACLE_VBOX_PACKAGE}/UserManual.pdf"

    waitKEY

    rstBlock "Mit der Installation wurden folgende Dienste eingerichtet:"
    echo
    TEE_stderr 0.5 <<EOF | bash | prefix_stdout
systemctl list-units 'vbox*' --all
EOF
    waitKEY

    rstHeading "Überprüfung vboxuser-Gruppe" section

    rstBlock "Mit der Installation wurde die Gruppe '${VBOXUSERS_GROUP}'
eingerichtet. Damit ein Benutzer VirtualBox nutzen kann, muss er zu dieser
Gruppe gehören::

  sudo usermod -a -G ${VBOXUSERS_GROUP} username

Siehe Kapitel 'The vboxusers group' https://www.virtualbox.org/manual/ch02.html
"

    if ! getent group ${VBOXUSERS_GROUP} > /dev/null; then
	err_msg "Die Gruppe ${VBOXUSERS_GROUP} existiert nicht!!!"
    else
	TEE_stderr <<EOF | bash | prefix_stdout
getent group ${VBOXUSERS_GROUP}
EOF
    fi
    waitKEY
}

# ----------------------------------------------------------------------------
installExtensionPack() {
    rstBlock "Installation des Extension-Pack & Guest-Additions"
# ----------------------------------------------------------------------------

    local EXTPACK=$(stripFilenameFromUrl "${ORACLE_VBOX_EXTPACK_URL}")
    cacheDownload "${ORACLE_VBOX_EXTPACK_URL}" "${EXTPACK}"
    VBoxManage extpack install "${CACHE}/${EXTPACK}"
    waitKEY

    cacheDownload "${ORACLE_VBOX_GUEST_ADDONS_URL}" "${ORACLE_VBOX_GUEST_ADDONS_ISO}"

    cp "${CACHE}/${ORACLE_VBOX_GUEST_ADDONS_ISO}"  "/home/${VBOX_USER}/${ORACLE_VBOX_GUEST_ADDONS_ISO}"

    rstBlock "Die CD mit den 'GuestAdditions' (das Image) wurde in den Ordner

* /home/${VBOX_USER}/${ORACLE_VBOX_GUEST_ADDONS_ISO}

kopiert. Die CD muss in den GAST-Host *eingelegt* werden und dann muss in dem
GAST-Host die Installation durchgeführt werden."
    waitKEY

    rstBlock "Um RDP (Fernsteuerung) zu nutzen sollte nach der Installation das
System neu gebootet werden"

    waitKEY
}

# ----------------------------------------------------------------------------
deinstallExtensionPack() {
# ----------------------------------------------------------------------------

    rstHeading "De-Installation des Extension-Pack" section
    echo
    VBoxManage extpack uninstall "${ORACLE_VBOX_EXTPACK_NAME}"
    waitKEY
}


# # ----------------------------------------------------------------------------
# deinstall_vboxweb_service(){
#     rstHeading "VirtualBox WEB Service De-Installation"
# # ----------------------------------------------------------------------------

#     TEE_stderr 1 <<EOF | bash | prefix_stdout
#     service vboxweb-service stop
#     service vboxweb-service status
#     update-rc.d vbox-vm-manage disable
# EOF
#     waitKEY
# }




# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
