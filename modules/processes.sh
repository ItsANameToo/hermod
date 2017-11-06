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
    process_ark_node=$(pgrep -a node | grep ark-node | awk '{print $1}')

    if [ -z "$process_ark_node" ]; then
        read -p "ark-node is not running, do you want to start it? [y/n] :" choice

        case "$choice" in
            y|Y)
                heading "Starting ARK Node..."
                ark_start
                sleep 5
                success "ARK Node started!"
            ;;
            *)
                abort 0 "Aborting..."
            ;;
        esac
    fi

    process_ark_node=$(pgrep -a node | grep ark-node | awk '{print $1}')
    process_forever=$(forever --plain list | grep ${process_ark_node} | awk '{print $2}' | tail -c +2 | head -c -2)
}
