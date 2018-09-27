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

__load_setup(){
    if [[ ! -e "${CONFIG}_setup.sh" ]]; then
        cfg_msg "missing setup:"
        cfg_msg "    ${CONFIG}_setup.sh"
        cfg_msg "Mostly you will edit the CONFIG variable in ${REPO_ROOT}/.config"
        cfg_msg "To NOT continue with defaults press CTRL-C now!"
        read -n1 $_t -p "** press any [KEY] to continue **"
        printf "\n"
    else
        source ${CONFIG}_setup.sh
    fi
}

if [[ -z ${_SETUP_OK+x} ]]; then
    source ${REPO_ROOT}/utils/site-bash/setup.sh
    export _SETUP_OK
fi
