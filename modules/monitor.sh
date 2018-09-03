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

            # Sleep if greater than 0
            if (( $monitor_rebuild > 0 )); then
                sleep $monitor_rebuild
            fi
        else
            # monitor_chain_comparison_failed

            # monitor_blockchain_rebuild_triggered

            monitor_hashbangs

            monitor_ark
        fi

        # Reduce CPU Overhead
        if (( $monitor_interval > 0 )); then
            sleep $monitor_interval
        fi
    done

    info "Closing Monitor..."
}

monitor_chain_comparison_failed()
{
    if tail -n $monitor_lines $ark_log | grep -q "Chain comparison failed with peer"; then
        notify "Chain comparison failed with peer - Check your node!";
    fi
}

monitor_blockchain_rebuild_triggered()
{
    if tail -n $monitor_lines $ark_log | grep -q "Blockchain rebuild triggered"; then
        notify "Blockchain rebuild triggered - Check your node!";
    fi
}

monitor_ark()
{
    if tail -n $monitor_lines $ark_log | grep -q "Blockchain not ready to receive block"; then
        # Only Notify
        if [[ $trigger_method_notify = true && $trigger_method_rebuild = false ]]; then
            notify "Blockchain not ready to receive block - Check your node!";
        fi

        # Only Rebuild
        if [[ "$trigger_action" = "rebuild" && $trigger_method_rebuild = true ]]; then
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
}

monitor_hashbangs()
{
    local hashbang_occurrences=$(tail -n $monitor_lines $ark_log | grep -c "############################################")

    if [[ hashbang_occurrences -ge $monitor_lines ]]; then
        # Only Notify
        if [[ $trigger_method_notify = true && $trigger_method_rebuild = false ]]; then
            notify "Blockchain not ready to receive block - Check your node!";
        fi

        # Only Rebuild
        if [[ "$trigger_action" = "rebuild" && $trigger_method_rebuild = true ]]; then
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
}
