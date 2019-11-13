#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# --                             --  File:     log_sysinfo.sh
# -- Copyright (C) 2014 darmarIT --  Author:   Markus Heiser
# --     All rights reserved     --  mail:     markus.heiser@darmarIT.de
# --                             --  http://www.darmarIT.de
# ----------------------------------------------------------------------------
# Purpose:     log some system informations
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
#setupInfo
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

mkdir -p ${CONFIG}_sysinfo
chown -R ${SUDO_USER}:${SUDO_USER} ${CONFIG}_sysinfo

cd ${CONFIG}_sysinfo

# ----------------------------------------------------------------------------
rstHeading "Erstellen von Dateien mit diversen Infos zum System" part
# ----------------------------------------------------------------------------

rstBlock "Die Informationsdateien werden in dem Ordner ${CONFIG}_sysinfo
angelegt."

waitKEY 5

# ----------------------------------------------------------------------------
rstHeading "Festplatten Infos" chapter
# ----------------------------------------------------------------------------

rstBlock "Auflistung der Block Devices siehe: disks.txt"
sudo -H lsblk -o NAME,FSTYPE,UUID,RO,RM,SIZE,STATE,OWNER,GROUP,MODE,TYPE,MOUNTPOINT,LABEL,MODEL > disks.txt

# DEVICES=($($PYTHON  <<EOF
# from sdkTools.sysfs import sysfs
# for hd in sysfs.block.glob("[hs]d?"):
#   print(hd.NAME)
# EOF
# ))

ATA_DEVICES=( $(ls -1 /dev/disk/by-id/ata-* /dev/disk/by-id/nvme-* | grep -v "part[0-9]\$") )

for DEV in "${ATA_DEVICES[@]}"  ; do

    rstHeading "device: $(basename $DEV)" section

    LOG=drive.$(basename $DEV).txt
    rm -f $LOG
    rstBlock "Es wird ein kurzer Test der Performance durchgeführt (bitte warten)"
    rstBlock "Protokolldatei: \n\n  $LOG"

    rstHeading "Performance" chapter-nc        >> $LOG
    rstHeading "Test 1 mit Cache" section-nc   >> $LOG
    sudo -H hdparm -tT $DEV                    >> $LOG
    echo                                       >> $LOG
    rstHeading "Test 2 mit Cache" section-nc   >> $LOG
    sudo -H hdparm -tT $DEV                    >> $LOG
    echo                                       >> $LOG
    rstHeading "S.M.A.R.T." chapter-nc         >> $LOG
    sudo -H smartctl -H $DEV                      >> $LOG

    sudo -H smartctl -s on $DEV > /dev/null # enable SMART if it is not already enabled
    sudo -H smartctl -o on $DEV > /dev/null # automatic offline test on (zyklus 4h)

    _T=""

    if askNy "Soll ein AUFWENDIGER *Oberflächentest* durchgeführt werden?" 10; then
	_T="long"
    else
	if askNy "Soll ein kurzer *Selbsttest* durchgeführt werden?" 10; then
	_T="short"
	fi
    fi
    echo
    if [[ ! -z $_T ]]; then
	sudo -H smartctl -t $_T $DEV

	rstBlock "Der Test wird (im Hintergrund) durchgeführt, er kann sehr
lange dauern (Endzeit steht oben). Nach Abschluss des Tests sollte dieses Skript
nochmal aufgerufen werden um das (dann aktuelle) LOG in die Ausgabedatei zu
schreiben."
    fi

    rstBlock_stdin <<EOF
ACHTUNG:

  Die erzeugte LOG Ausgabe (in der Protokolldatei) ist immer vom *letzten* SMART
  Test."
EOF
    waitKEY 5
    sudo -H smartctl -a $DEV >> $LOG
    rstHeading "HD Info (hdparm -I)" chapter-nc >> $LOG
    sudo -H hdparm -I $DEV          >> $LOG
    echo
done

rstHeading "Hardware Infos (lshw)"
echo "  --> hardware.txt"
sudo -H lshw > hardware.txt
waitKEY 5

rstHeading "BIOS Infos (dmidecode)"
echo "  --> BIOS.txt"
sudo -H dmidecode > BIOS.txt
waitKEY 5

rstHeading "PCI Infos"
echo " --> pci.txt"
sudo -H lspci -vvvnn > pci.txt
waitKEY 5

rstHeading "usb Infos"
echo " --> usb.txt"
sudo -H lsusb --verbose > usb.txt
waitKEY 5

rstHeading "Devices"
echo "  --> ubuntu-drivers-devices.txt"
sudo -H ubuntu-drivers devices > ubuntu-drivers-devices.txt
echo

# Das funktioniert natürlich nur wenn man das DISPLAY geöffnet hat ..
rstHeading "Display infos"
echo "  --> xrandr.txt"
sudo -H xrandr --verbose > xrandr.txt
echo
