#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update handsOn post-handle
# ----------------------------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

rstHeading "Update ENDE"

if [ -f /var/run/reboot-required ]; then
    rstHeading "== Es wird ein Reboot des Computers ($HOSTNAME) empfohlen ==" part
    rstBlock "Vor dem Reboot sollten alle Programme geschlossen werden!!"
    if askYesNo "Soll **$HOSTNAME** neu gebootet werden?" Ny 30; then
        sudo reboot
    fi
else
    rstBlock "Neustart des Computers nach diesem Update nicht erforderlich"
fi

waitKEY
