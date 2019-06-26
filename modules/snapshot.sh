#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# Copyright (c) 2019 Munich ArkLand Delegate <admin@ark.land>
# Copyright (c) 2019 ItsANameToo <itsanametoo@protonmail.com>
# Copyright (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

snapshot()
{
    # create snapshot directory if it doesn't exist yet
    mkdir -p "$HOME/.local/share/ark-core/$core_network/snapshots"

    # go into the snapshot directory
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    # check if directory is empty
    has_snapshots=$(ls -1 . | wc -l)

    # if the directory is empty, take a fresh snapshot,
    # else, append to the last snapshot
    if [ $has_snapshots -eq 0 ] 
    then
        snapshot_dump
    else
        snapshot_append

        snapshot_purge
    fi
}

snapshot_dump()
{
    cd "$HOME"

    log "[SNAPSHOTS] Taking a fresh snapshot...";

    ark snapshot:dump --network="$core_network" 2>&1 | tee ${hermod_dir}/snapshot.log

    doneCount=$(tail -n 6 ${hermod_dir}/snapshot.log | grep -c "done")

    if [ $doneCount -eq 3 ]; then
        log "[SNAPSHOTS] Done.";
    else
        snapshot_remove_most_recent
        log "[SNAPSHOTS] Failed, see $hermod_dir/snapshot.log for details.";
    fi
}

snapshot_append()
{
    most_recent_snapshot=$(ls -td * | head -1)

    cd "$HOME"

    log "[SNAPSHOTS] Appending to snapshot: $most_recent_snapshot...";

    ark snapshot:dump --network="$core_network" --blocks="$most_recent_snapshot" 2>&1 | tee ${hermod_dir}/snapshot.log

    doneCount=$(tail -n 6 ${hermod_dir}/snapshot.log | grep -c "done")

    if [ $doneCount -eq 3 ]; then
        log "[SNAPSHOTS] Done.";
    else
        snapshot_remove_most_recent
        log "[SNAPSHOTS] Failed, see $hermod_dir/snapshot.log for details.";
    fi
}

snapshot_purge()
{
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    retain_counter=$(($snapshots_retain + 1))

    # delete old snapshots
    ls -t | tail -n +$retain_counter | xargs --no-run-if-empty rm -r
}

snapshot_rollback()
{
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    most_recent_snapshot=$(ls -td * | head -1)

    # trim the first 2 characters of the file name
    most_recent_snapshot="${most_recent_snapshot:2}"

    log "[SNAPSHOTS] Stopping core...";

    pm2 stop all

    log "[SNAPSHOTS] Rolling back the database to block $most_recent_snapshot";

    cd "$HOME"

    ark snapshot:rollback --network="$core_network" --height="$most_recent_snapshot"

    log "[SNAPSHOTS] Done.";

    log "[SNAPSHOTS] Starting core...";

    pm2 start all

    log "[SNAPSHOTS] Done.";
}

snapshot_remove_most_recent()
{
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    most_recent_snapshot=$(ls -td * | head -1)

    rm -rf $most_recent_snapshot
}

snapshot_share()
{
    # create share directory if it doesn't exist yet
    mkdir -p "$hermod_dir/snapshots"

    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    most_recent_snapshot=$(ls -td * | head -1)

    echo "[SNAPSHOTS-SHARE] Verifying snapshot...";

    ark snapshot:verify  --network="$core_network" --blocks="$most_recent_snapshot" 2>&1 | tee ${hermod_dir}/snapshot-verify.log

    successCount=$(tail -n 6 ${hermod_dir}/snapshot-verify.log | grep -c "succesfully verified")

    if [ $successCount -eq 2 ]; then
        echo "[SNAPSHOTS-SHARE] Snapshot $most_recent_snapshot is valid.";
        rm ${hermod_dir}/snapshot-verify.log

        # combine snapshot files into a single file
        tar cvf "$hermod_dir/snapshots/$most_recent_snapshot.tar" "$most_recent_snapshot" > /dev/null && cd "$hermod_dir/snapshots" 

        # start webserver
        echo "[SNAPSHOTS-SHARE] Starting webserver...";
        npx http-server -p 8080 > /dev/null &

        # start tunnel
        echo "[SNAPSHOTS-SHARE] Starting tunnel...";
        npx localtunnel -p 8080 &

        echo "[SNAPSHOTS-SHARE] Running on port 8080. When you're done, kill this command with CTRL + C to stop the webserver and tunnel.";

        while true
        do
            # Keeps the script running. The webserver and tunnel will stay up as long as this script is running.
            sleep 3
        done

    else
        log "[SNAPSHOTS] Snapshot $most_recent_snapshot has errors, see $hermod_dir/snapshot-verify.log for details.";
    fi
}
