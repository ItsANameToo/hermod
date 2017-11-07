#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

process_vars()
{
    process_postgres=$(pgrep -a postgres | awk '{print $1}')

    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    process_ark_node=$(pgrep -a node | grep ark-node | awk '{print $1}')

    if [ -z "$process_ark_node" ]; then
        abort 0 "ARK Process is not running..."
    fi
}
