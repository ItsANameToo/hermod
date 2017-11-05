#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# -------------------------
# Requirements
# -------------------------

if [[ $BASH_VERSINFO < 4 ]]; then
    echo "Yikes! You need at least bash-4.0 to run this script."
    exit 1
fi

# -------------------------
# Root User === Exit
# -------------------------

if [ "$(id -u)" = "0" ]; then
    clear
    error "This script should NOT be started using sudo or as the root user!"
    exit 1
fi

# -------------------------
# Initialization
# -------------------------

NODE_PATH=$(which node | rev | cut -c6- | rev)
PATH="$NODE_PATH:$PATH"
export PATH

# -------------------------
# Version
# -------------------------

NOAH_VERSION=$(cat version)

# -------------------------
# Includes
# -------------------------

directory_noah=$(dirname $0)
