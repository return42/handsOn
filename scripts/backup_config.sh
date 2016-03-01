#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# backup config
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh
sudoOrExit

# ----------------------------------------------------------------------------
# Config
# ----------------------------------------------------------------------------

if [[ -z ${CONFIG_BACKUP_ENCRYPTED} ]]; then
    err_msg "CONFIG_BACKUP_ENCRYPTED nicht definiert"
    exit
fi

if [[ -z ${CONFIG_BACKUP} ]]; then
    err_msg "CONFIG_BACKUP nicht definiert"
    exit
fi

if [[ -z ${CONFIG} ]]; then
    err_msg "CONFIG nicht definiert"
    exit
fi

set +o history

# ----------------------------------------------------------------------------
rstHeading "Backup der wichtigsten Konfigurationen" part
# ----------------------------------------------------------------------------

rstBlock "Sicherung erfolgt unter:

  CONFIG  : ${CONFIG}"

if askNy "Soll die alte Sicherung gelöscht werden?" 10 ; then
    rm -rf ${CONFIG}
fi

mkdir -p ${CONFIG}
cd ${CONFIG}

echo

# ----------------------------------------------------------------------------
rstHeading "Verschlüsselte Backups"
# ----------------------------------------------------------------------------
echo
for ITEM in "${CONFIG_BACKUP_ENCRYPTED[@]}"; do
    if [[ -d ${ITEM} ]] ; then
	echo "folder : ${ITEM}"
    else
	echo "file   : ${ITEM}"
    fi
done

if askNy "Soll eine Sicherung der zu verschlüsselnden Daten erfolgen?" 10 ; then
    echo
    CONFIG_cryptedBackup "${CONFIG_BACKUP_ENCRYPTED[@]}"
else
    echo
    echo "ACHTUNG: die zu verschlüsselnden Dateien und Ordner werden nicht gesichert!"
fi
echo

# ----------------------------------------------------------------------------
rstHeading "Unverschlüsselte Backups"
# ----------------------------------------------------------------------------
echo
CONFIG_Backup "${CONFIG_BACKUP[@]}"
