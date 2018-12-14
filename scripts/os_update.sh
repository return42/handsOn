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
	;;

esac
