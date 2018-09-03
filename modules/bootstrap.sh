#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

if [[ $BASH_VERSINFO < 4 ]]; then
    abort 1 'You need at least bash-4.0 to run this script.'
fi

if [ "$(id -u)" = "0" ]; then
    abort 1 'This script should NOT be started using sudo or as the root user!'
fi

if [[ -z "$HOME" ]]; then
    abort 1 "\$HOME is not defined. Please set it first."
fi
