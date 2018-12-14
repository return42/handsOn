#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     update handsOn & OS
# ----------------------------------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/setup.sh"

cd "${REPO_ROOT}"

"${REPO_ROOT}/update/update_all_pre.sh"
"${REPO_ROOT}/update/update_all_now.sh"
"${REPO_ROOT}/update/update_all_post.sh"
