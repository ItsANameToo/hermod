#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# TODO: update the monitoring statements

monitor()
{
    heading "Starting Monitor..."

    while true; do
        if tail -n $monitor_lines $ark_log | grep -q "Forged new block"; then
            notify "Forged a new block!";

            # TODO: add sleep option after notification
            sleep 10
        else
            monitor_quorum

            monitor_blocks

            monitor_disregarded

            monitor_synced

            monitor_stopped

            monitor_started
        fi

        # Reduce CPU Overhead
        if (( $monitor_interval > 0 )); then
            sleep $monitor_interval
        fi
    done

    info "Closing Monitor..."
}

monitor_quorum()
{
    if tail -n $monitor_lines $ark_log | grep -q "Fork 6 - Not enough quorum to forge next block"; then
        notify "[NO QUORUM] - Fork 6; Not enough quorum to forge";
    fi

    if tail -n $monitor_lines $ark_log | grep -q "Network reach is not sufficient to get quorum"; then
        notify "[NO QUORUM] - Insufficient network reach for quorum";
    fi
}

monitor_blocks() {
    if tail -n $monitor_lines $ark_log | grep -q "Delegate $delegate_username ($delegate_public_key) just missed a block"; then
        notify "[MISSED BLOCK] - You have missed a block this round";
    fi
}

monitor_disregarded() {
    if tail -n $monitor_lines $ark_log | grep -q "disregarded because already in blockchain"; then
        notify "[BLOCK DISREGARDED] - Block disregarded because already in blockchain";
    fi
}

monitor_synced() {
    if tail -n $monitor_lines $ark_log | grep -q "NOTSYNCED"; then
        notify "[OUT OF SYNC] - Node out of sync";
    fi

    if tail -n $monitor_lines $ark_log | grep -q "Tried to sync 5 times to different nodes, looks like the network is missing blocks"; then
        notify "[OUT OF SYNC] - Tried syncing to different nodes but failed";
    fi

    # TODO: add sleep option after notification
    sleep 10
}

monitor_stopped() {
    if tail -n $monitor_lines $ark_log | grep -q -e "Disconnecting" -e "Stopping" -e "STOP" -e "The blockchain has been stopped"; then
        notify "[STOPPED] - Node stopped";
    fi
}

monitor_started() {
    if tail -n $monitor_lines $ark_log | grep -q -e "Starting Blockchain" -e "Verifying database integrity" -e "START"; then
        notify "[STARTED] - Node started";
    fi
}