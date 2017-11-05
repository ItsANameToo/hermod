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
    process_postgres=$(pgrep -a "postgres" | awk '{print $1}')
    process_ark_node=$(pgrep -a "node" | grep ark-node | awk '{print $1}')

    if [ -z "$process_ark_node" ]; then
        heading "Starting ARK Node..."
        node_start
        sleep 5
        success "ARK Node started!"
    fi

    process_ark_node=$(pgrep -a "node" | grep ark-node | awk '{print $1}')
    process_forever=$(forever --plain list | grep ${process_ark_node} | sed -nr 's/.*\[(.*)\].*/\1/p')
}
