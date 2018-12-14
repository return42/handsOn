#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update handsOn post-handle
# ----------------------------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

rstHeading "Update ENDE"
if [ -f /var/run/reboot-required ]; then
    askReboot Ny 30
else
    rstBlock "Neustart nicht erforderlich"
fi

waitKEY
