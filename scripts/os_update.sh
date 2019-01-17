#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update os
# ----------------------------------------------------------------------------

source "$(dirname "${BASH_SOURCE[0]}")/setup.sh"
sudoOrExit

# ----------------------------------------------------------------------------
# main
# ----------------------------------------------------------------------------

rstHeading "Update / Upgrade der Pakete" part
echo

case "$(lsb_release -si)" in

    Ubuntu|Debian)

	apt-get update -y
	apt-get dist-upgrade -y
	apt-get autoclean -y
	apt-get autoremove -y
	FORCE_TIMEOUT=0 "${SCRIPT_FOLDER}/vbox.sh" update
	FORCE_TIMEOUT=0 "${SCRIPT_FOLDER}/firefox_setup.sh" update
        ;;

esac
