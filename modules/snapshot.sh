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
    # go into the snapshot dir
    cd "~/.local/share/ark-core/$core_network/snapshots"

    # check if dir is empty
    has_snapshots=$(ls -1 . | wc -l)

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

    yarn dump:$core_network

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
    cd "~/.local/share/ark-core/$core_network/snapshots"

    # delete old snapshots
    ls -t | tail -n +$snapshots_retain | xargs rm -r
}