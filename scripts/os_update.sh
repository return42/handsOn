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
        echo "xxx"
	if ! apt-get dist-upgrade -y;  then

            rstBlock "${BRed}Es gab ein Problem beim Update des Systems${_color_Off}

Bitte lesen Sie obige Fehlermeldungen und entscheiden ob eine Fehlerbehandlung
erforderlich ist.  Steht dort etwas wie 'konnte Sperre nicht bekommen', dann
läuft parallel ein anderes Programm, dass Software installiert (oder ein
Systemupate macht).

In diesem Fall brechen Sie dieses handsOn Update erst mal mit STRG-C
ab.  Das andere Programm muss man beenden oder zu ende laufen
lassen und dann nochmal dieses handsOn Update NEU starten."
            waitKEY

        fi
	apt-get autoclean -y
	apt-get autoremove -y
	FORCE_TIMEOUT=0 "${SCRIPT_FOLDER}/vbox.sh" update
	FORCE_TIMEOUT=0 "${SCRIPT_FOLDER}/firefox_setup.sh" update
        ;;

esac
