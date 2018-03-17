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
SCRIPT_FOLDER=${REPO_ROOT}/scripts

# TEMPLATES: Ordner in dem die vorlagen für die Setups zu finden sind
#
TEMPLATES="${REPO_ROOT}/templates"

# CACHE: Ordner in dem die Downloads und Builds gecached werden
#
CACHE=${REPO_ROOT}/cache

# CONFIG: Ordner unter dem die Konfiguration eines Hosts gesichert werden soll
# Das wird nicht hier gesetzt sondern in der .config Datei (templates/do_config)
#
# CONFIG="${REPO_ROOT}/hostSetup/$(hostname)"

if [[ ! -e "${REPO_ROOT}/.config" ]]; then
    cfg_msg "installing ${REPO_ROOT}/.config"
    cp "${TEMPLATES}/dot_config" "${REPO_ROOT}/.config"
fi

source ${REPO_ROOT}/.config

if [[ ! -e "${CONFIG}_setup.sh" ]]; then
    cfg_msg "missing setup:"
    cfg_msg "    ${CONFIG}_setup.sh"
    cfg_msg "Mostly you will edit the CONFIG variable in ${REPO_ROOT}/.config"
    cfg_msg "which points to your setup::"
    cfg_msg "    CONFIG=/path/to/my-config/$(hostname)"
    cfg_msg "Or use::"
    cfg_msg "    CONFIG=/path/to/my-config/$(hostname) $0 $*"
    cfg_msg "For more info about setup, read::"
    cfg_msg "    ${REPO_ROOT}/hostSetup/MEMO.rst"
    cfg_msg "To NOT continue with defaults press CTRL-C now!"
    read -n1 $_t -p "** press any [KEY] to continue **"
    printf "\n"
fi

source ${CONFIG}_setup.sh
source ${SCRIPT_FOLDER}/common.sh
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
