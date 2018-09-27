#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     common environment customization
# ----------------------------------------------------------------------------

if [[ -z "${REPO_ROOT}" ]]; then
    REPO_ROOT="$(dirname ${BASH_SOURCE[0]})"
    while([ -h "${REPO_ROOT}" ]); do
        REPO_ROOT=`readlink "${REPO_ROOT}"`
    done
    REPO_ROOT=$(cd ${REPO_ROOT}/.. && pwd -P )
fi


_color_Off='\e[0m'  # Text Reset
BYellow='\e[1;33m'

cfg_msg() {
    echo -e "${BYellow}CFG:${_color_Off} $*" >&2
}

# SCRIPT_FOLDER: Ordner mit den Skripten für die Setups
#
#SCRIPT_FOLDER=${REPO_ROOT}/scripts

# TEMPLATES: Ordner in dem die vorlagen für die Setups zu finden sind
#
#TEMPLATES="${REPO_ROOT}/templates"

# CACHE: Ordner in dem die Downloads und Builds gecached werden
#
CACHE=${REPO_ROOT}/cache

# CONFIG: Ordner unter dem die Konfiguration eines Hosts gesichert werden soll
# Das wird nicht hier gesetzt sondern in der .config Datei (templates/do_config)
#
# CONFIG="${REPO_ROOT}/hostSetup/$(hostname)"

# WWW_USER: Benutzer für die Prozesse des WEB-Servers
#
#WWW_USER=www-data

# WWW_FOLDER: Ordner in dem die Resourcen des WEB-Servers liegen
#
#WWW_FOLDER=/var/www

# =========
# toolchain
# =========

# THREE_WAY_MERGE_CMD: Kommando oder Funktion mit der ein (interaktives)
# drei-Wege Merge gemacht werden kann. Das Kommando muss die vier Argumente für
# Dateinamen entgegennehmen.
#
#    $THREE_WAY_MERGE_CMD {mine} {yours} {ancestor} {merged}
#
#THREE_WAY_MERGE_CMD=merge3FilesWithEmacs

# MERGE_CMD: Kommando oder Funktion mit der ein (interaktiver) Merge gemacht
# werden kann. Das Kommando muss die drei Argumente für Dateinamen
# entgegennehmen.
#
#     $MERGE_CMD {file_a} {file_b} {merged}
#
#MERGE_CMD=merge2FilesWithEmacs

# DIFF_CMD: Kommando oder Funktion mit der ein diff angezeigt werden soll. Im
# Default wird ``colordiff`` verwendet, wenn das nicht vorhanden ist, dann wird
# das ganz normale ``diff`` verwendet.
#
#DIFF_CMD=colordiff

# =====
# SAMBA
# =====

# SAMBA_SERVER=127.0.0.1

# =====================
# Debian's Apache Setup
# =====================

# APACHE_SETUP="/etc/apache2"
# APACHE_SITES_AVAILABE="${APACHE_SETUP}/sites-available"
# APACHE_MODS_AVAILABE="${APACHE_SETUP}/mods-available"
# APACHE_CONF_AVAILABE="${APACHE_SETUP}/conf-available"


# Debian's OpenLDAP Setup
# =======================

# LDAP_SERVER="myserver"
# LDAP_SSL_PORT=636
# OPENLDAP_USER=openldap
# SLAPD_DBDIR=/var/lib/ldap
# SLAPD_CONF="/etc/ldap/slapd.d"

# =======
# Firefox
# =======

# FFOX_GLOBAL_EXTENSIONS=/usr/lib/firefox-addons/extensions

# =====
# GNOME
# =====

# GNOME_APPL_FOLDER=/usr/share/applications

# dot_config
# ==========

if [[ ! -e "${REPO_ROOT}/.config" ]]; then
    cfg_msg "installing ${REPO_ROOT}/.config"
    cp "$(dirname ${BASH_SOURCE[0]})/setup_dot_config" "${REPO_ROOT}/.config"
    chown -R ${SUDO_USER}:${SUDO_USER} "${REPO_ROOT}/.config"
fi
source ${REPO_ROOT}/.config

# load setup
# ==========

if declare -F __load_setup >/dev/null
then
    __load_setup
fi

source ${REPO_ROOT}/utils/site-bash/common.sh
checkEnviroment

# ----------------------------------------------------------------------------
setupInfo () {
# ----------------------------------------------------------------------------
    rstHeading "setup info"
    echo "
CONFIG        : ${CONFIG}
ORGANIZATION  : ${ORGANIZATION}

REPO_ROOT     : ${REPO_ROOT}
SCRIPT_FOLDER : ${SCRIPT_FOLDER}
TEMPLATES     : ${TEMPLATES}
CACHE         : ${CACHE}
WWW_USER      : ${WWW_USER}
WWW_FOLDER    : ${WWW_FOLDER}
DEB_ARCH      : ${DEB_ARCH}

Apache:

  APACHE_SETUP           : ${APACHE_SETUP}
  FFOX_GLOBAL_EXTENSIONS : ${FFOX_GLOBAL_EXTENSIONS}
  GNOME_APPL_FOLDER      : ${GNOME_APPL_FOLDER}

Open LDAP:

  SLAPD_DBDIR   : ${SLAPD_DBDIR}
  SLAPD_CONF    : ${SLAPD_CONF}
  LDAP_SERVER   : ${LDAP_SERVER}
  LDAP_SSL_PORT : ${LDAP_SSL_PORT}
  OPENLDAP_USER : ${OPENLDAP_USER}

ldapscripts DIT (defaults):

  LDAP_AUTH_BaseDN  : ${LDAP_AUTH_BaseDN}
  LDAP_AUTH_DC      : ${LDAP_AUTH_DC}

LSB (Linux Standard Base) and Distribution information.

  DISTRIB_ID          : ${DISTRIB_ID}
  DISTRIB_RELEASE     : ${DISTRIB_RELEASE}
  DISTRIB_CODENAME    : ${DISTRIB_CODENAME}
  DISTRIB_DESCRIPTION : ${DISTRIB_DESCRIPTION}

CWD : $(pwd -P)"
}


