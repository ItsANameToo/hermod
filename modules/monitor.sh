#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# Copyright (c) 2019 ItsANameToo <itsanametoo@protonmail.com>
# Copyright (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

monitor()
{
    heading "Starting Monitor..."

    last_line='';
    last_line_count=0;
    log_file="${core_log_path}/*.log"

    while true; do
        
        monitor_forged

        monitor_quorum

        monitor_blocks

        monitor_disregarded

        monitor_synced

        monitor_stopped

        monitor_started

        monitor_relay

        monitor_double_forgery

        monitor_network_rollback

        monitor_round_saved

        monitor_fork

        monitor_last_line

        # Reduce CPU Overhead
        if (( $monitor_interval > 0 )); then
            sleep $monitor_interval
        fi
    done

    info "Closing Monitor..."
}

monitor_forged()
{
    # TODO: mostly for testing, can be removed after
    if tail -n $monitor_lines $log_file | grep -q "Forged new block"; then
        log "[FORGED] Forged a new block!";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_quorum()
{
    if tail -n $monitor_lines $log_file | grep -q "Fork 6 - Not enough quorum to forge next block"; then
        notify "[NO QUORUM] - Fork 6; Not enough quorum to forge";
    fi

    if tail -n $monitor_lines $log_file | grep -q "Network reach is not sufficient to get quorum"; then
        notify "[NO QUORUM] - Insufficient network reach for quorum";
    fi
}

monitor_blocks()
{
    if tail -n $monitor_lines $log_file | grep -q "Delegate $delegate_username ($delegate_public_key) just missed a block"; then
        notify "[MISSED BLOCK] - You have missed a block this round";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_disregarded()
{
    if tail -n $monitor_lines $log_file | grep -q "disregarded because already in blockchain"; then
        notify "[BLOCK DISREGARDED] - Block disregarded because already in blockchain";
    fi
}

monitor_synced()
{
    if tail -n $monitor_lines $log_file | grep -q "NOTSYNCED"; then
        notify "[OUT OF SYNC] - Node out of sync";

        sleep $monitor_sleep_after_notif
    fi

    if tail -n $monitor_lines $log_file | grep -q "Tried to sync 5 times to different nodes, looks like the network is missing blocks"; then
        notify "[OUT OF SYNC] - Tried syncing to different nodes but failed";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_stopped()
{
    if tail -n $monitor_lines $ark_log | grep -q -e "Disconnecting" -e "Stopping" -e "STOP" -e "The blockchain has been stopped"; then
        notify "[STOPPING] - Node stopping / stopped";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_started()
{
    if tail -n $monitor_lines $ark_log | grep -q -e "Starting Blockchain" -e "Verifying database integrity" -e "START"; then
        notify "[STARTING] - Node starting / started";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_relay()
{
    if tail -n $monitor_lines $log_file | grep -q "didn't respond to the forger. Trying another host"; then 
        notify "[RELAY] - Relay did not respond to the forger";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_double_forgery()
{
    if tail -n $monitor_lines $log_file | grep -q "Possible double forging delegate"; then 
        notify "[DOUBLE FORGERY] - Possible double forgery - Network might be unstable";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_network_rollback()
{
    if tail -n $monitor_lines $log_file | grep -q "is too low. Going to rollback"; then 
        notify "[ROLLBACK] - Node is rolling back - Network might be unstable";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_fork()
{
    if tail -n $monitor_lines $log_file | grep -q "event 'FORK':"; then 
        notify "[FORK] - Node has forked - Network might be unstable";

        sleep $monitor_sleep_after_notif
    fi
}

monitor_round_saved()
{
    if tail -n $monitor_lines $log_file | grep -q "Saving round"; then

        if [[ $snapshots_enabled == "true" ]];
        then
            # run snapshot() function when rounds are saved
            snapshot
        fi
        
        sleep $monitor_sleep_after_notif
    fi
}

monitor_last_line()
{
    new_last_line=$( tail -n 1 $log_file );

    if [[ "$new_last_line" = "$last_line" ]]; then
        last_line_count=$(($last_line_count + 1))

        if (($last_line_count >= 3)); then
            last_line_count=0;
            notify "[HALTED] - Node logs have not updated in a while; maybe the node has crashed";

            sleep 60
        fi
    else
        last_line_count=0
    fi

    last_line=$new_last_line
}