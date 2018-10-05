#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     common environment customization
# ----------------------------------------------------------------------------

GET_STARTET_URL=https://return42.github.io/handsOn/get_started.html

if [[ -z "${REPO_ROOT}" ]]; then
    REPO_ROOT="$(dirname ${BASH_SOURCE[0]})"
    while([ -h "${REPO_ROOT}" ]); do
        REPO_ROOT=`readlink "${REPO_ROOT}"`
    done
    REPO_ROOT=$(cd ${REPO_ROOT}/.. && pwd -P )
fi

_color_Off='\e[0m'  # Text Reset
BYellow='\e[1;33m'

init_msg() {
    echo -e "${BYellow}INIT:${_color_Off} $*"
}

if [[ ! -e "${REPO_ROOT}/.config" ]]; then

    init_msg "It seems to be the first time you are using handsOn scripts,"
    init_msg "a default setup is created right now ..."

    init_msg " --> create initial ${REPO_ROOT}/.config"
    cp -ua "${REPO_ROOT}/templates/setup_dot_config" "${REPO_ROOT}/.config"
    source "${REPO_ROOT}/.config"

    init_msg " --> create version controlled folder to store configurations:"
    init_msg "      $(dirname ${CONFIG})"
    cp -uar "${REPO_ROOT}/templates/hostSetup" "${REPO_ROOT}"

    pushd "${REPO_ROOT}/hostSetup" > /dev/null

    git init > /dev/null
    init_msg " --> create inital setup from example_setup.sh in"
    init_msg "      ${CONFIG}_setup.sh"
    cp -ua "${REPO_ROOT}/templates/hostSetup/example_setup.sh" "${CONFIG}_setup.sh"
    chown -R ${SUDO_USER}:${SUDO_USER} .

    popd > /dev/null

    init_msg "If all this is not what you want than visit: "
    init_msg "  - ${GET_STARTET_URL}"
    init_msg "and check your settings in:"
    init_msg "  - ${REPO_ROOT}/.config "
    init_msg "  - ${CONFIG}_setup.sh"
    read -n1 -t 30 -p "** press any [KEY] to continue **"
    echo
fi

hook_load_setup_pre(){
    if [[ ! -e "${CONFIG}_setup.sh" ]]; then
	init_msg " --> create inital setup from example_setup.sh in"
	init_msg "      ${CONFIG}_setup.sh"
	cp -ua "${REPO_ROOT}/templates/hostSetup/example_setup.sh" "${CONFIG}_setup.sh"
	chown -R ${SUDO_USER}:${SUDO_USER} .
    fi
    source "${CONFIG}_setup.sh"
}

hook_load_setup_post(){
    :
}


if [[ -z ${_SETUP_OK+x} ]]; then
    source ${REPO_ROOT}/utils/site-bash/setup.sh
    export _SETUP_OK
fi

# ----------------------------------------------------------------------------
setupInfo () {
# ----------------------------------------------------------------------------
    rstHeading "handsOn setup"

    echo "
loaded ${CONFIG}_setup.sh

CONFIG        : ${CONFIG}
ORGANIZATION  : ${ORGANIZATION}

REPO_ROOT     : ${REPO_ROOT}
SCRIPT_FOLDER : ${SCRIPT_FOLDER}
TEMPLATES     : ${TEMPLATES}
CACHE         : ${CACHE}
WWW_USER      : ${WWW_USER}
WWW_FOLDER    : ${WWW_FOLDER}
DEB_ARCH      : ${DEB_ARCH}

Services & Apps:

  APACHE_SETUP           : ${APACHE_SETUP}
  SAMBA_SERVER           : ${SAMBA_SERVER}
  FFOX_GLOBAL_EXTENSIONS : ${FFOX_GLOBAL_EXTENSIONS}
  GNOME_APPL_FOLDER      : ${GNOME_APPL_FOLDER}

Open LDAP:

  LDAP_SERVER   : ${LDAP_SERVER}
  LDAP_SSL_PORT : ${LDAP_SSL_PORT}
  OPENLDAP_USER : ${OPENLDAP_USER}
  SLAPD_CONF    : ${SLAPD_CONF}
  SLAPD_DBDIR   : ${SLAPD_DBDIR}

ldapscripts DIT (defaults):

  LDAP_AUTH_BaseDN  : ${LDAP_AUTH_BaseDN}
  LDAP_AUTH_DC      : ${LDAP_AUTH_DC}

LSB (Linux Standard Base) and Distribution information.

  DISTRIB_ID          : ${DISTRIB_ID}
  DISTRIB_RELEASE     : ${DISTRIB_RELEASE}
  DISTRIB_CODENAME    : ${DISTRIB_CODENAME}
  DISTRIB_DESCRIPTION : ${DISTRIB_DESCRIPTION}

Tools:

  MERGE_CMD           : ${MERGE_CMD}
  THREE_WAY_MERGE_CMD : ${THREE_WAY_MERGE_CMD}

CWD : $(pwd -P)"
}

case $1 in
    info) setupInfo;;
esac
