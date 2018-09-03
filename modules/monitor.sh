#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

monitor()
{
    heading "Starting Monitor..."

    while true; do
        if tail -n $monitor_lines $ark_log | grep -q "Forked from network"; then
            notify "Forked from network - Check your node!";
        else
            monitor_hashbangs
            
            monitor_ark
        fi
    done

    info "Closing Monitor..."
}

monitor_ark()
{
    if tail -n $monitor_lines $ark_log | grep -q "Blockchain not ready to receive block"; then
        # Day >>> Only Notify
        if [[ $trigger_method_notify = true && $trigger_method_rebuild = false ]]; then
            notify "ark-node out of sync - rebuild required...";
        fi

        # Night >>> Only Rebuild
        if [[ $trigger_method_rebuild = true ]]; then
            if [[ $relay_enabled = true ]]; then
                rebuild_with_relay
            else
                rebuild_via_monitor
            fi
        fi

        # Sleep if greater than 0
        if (( $monitor_rebuild > 0 )); then
            sleep $monitor_rebuild
        fi
    fi

    # Reduce CPU Overhead
    if (( $monitor_interval > 0 )); then
        sleep $monitor_interval
    fi
}

monitor_hashbangs()
{
    local hashbang_occurrences=$(tail -n $monitor_lines $ark_log | grep -c "############################################")

    if [[ hashbang_occurrences -ge $monitor_lines ]]; then
        # Day >>> Only Notify
        if [[ $trigger_method_notify = true && $trigger_method_rebuild = false ]]; then
            notify "ark-node out of sync - rebuild required...";
        fi

        # Night >>> Only Rebuild
        if [[ $trigger_method_rebuild = true ]]; then
            if [[ $relay_enabled = true ]]; then
                rebuild_with_relay
            else
                rebuild_via_monitor
            fi
        fi

        # Sleep if greater than 0
        if (( $monitor_rebuild > 0 )); then
            sleep $monitor_rebuild
        fi
    fi

    # Reduce CPU Overhead
    if (( $monitor_interval > 0 )); then
        sleep $monitor_interval
    fi
}
