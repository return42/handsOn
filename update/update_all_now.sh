#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update handsOn now-handle
# ----------------------------------------------------------------------------

source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

pkexec "${SCRIPT_FOLDER}/os_update.sh"
