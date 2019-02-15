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
    cd "$core_path/packages/core-snapshots-cli"

    log "[SNAPSHOTS] Taking a fresh snapshot...";

    yarn dump:$core_network &

    log "[SNAPSHOTS] Done.";
}

snapshot_append()
{
    # get most recent snapshot
    most_recent_snapshot=$(ls -td * | head -1)

    cd "$core_path/packages/core-snapshots-cli"

    log "[SNAPSHOTS] Appending to snapshot: $most_recent_snapshot...";

    yarn dump:$core_network --blocks $most_recent_snapshot

    log "[SNAPSHOTS] Done.";
}

snapshot_purge()
{
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    # delete old snapshots
    ls -t | tail -n +$snapshots_retain | xargs rm -r
}

snapshot_rollback()
{
    cd "$HOME/.local/share/ark-core/$core_network/snapshots"

    # get most recent snapshot
    most_recent_snapshot=$(ls -td * | head -1)

    # trim the first 2 characters of the file name
    most_recent_snapshot="${most_recent_snapshot:2}"

    log "[SNAPSHOTS] Stopping core...";

    pm2 stop all

    log "[SNAPSHOTS] Rolling back the database to block $most_recent_snapshot";

    cd "$core_path/packages/core-snapshots-cli"

    yarn rollback:$core_network --height $most_recent_snapshot

    log "[SNAPSHOTS] Done.";

    log "[SNAPSHOTS] Starting core...";

    pm2 start all

    log "[SNAPSHOTS] Done.";
}