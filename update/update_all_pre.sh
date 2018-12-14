#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update handsOn pre-handle
# ----------------------------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

rstHeading "handsOn update git Reposeorie"
git pull
