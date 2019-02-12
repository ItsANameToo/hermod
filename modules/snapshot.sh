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
    cd ~/.local/share/ark-core/devnet/snapshots

    # check if dir is empty
    has_snapshots=$(ls -1 . | wc -l)

    notify "[DEBUG] retain: $snapshots_retain";

    if [ $has_snapshots -eq 0 ] 
    then
        snapshot_dump
    else
        snapshot_append
    fi
}

snapshot_dump()
{
    cd ~/ark-core/packages/core-snapshots-cli

    notify "[SNAPSHOTS] Taking a fresh snapshot";

    yarn dump:devnet
}

snapshot_append()
{
    # get most recent snapshot
    most_recent_snapshot=$(ls -td * | head -1)

    cd ~/ark-core/packages/core-snapshots-cli

    notify "[SNAPSHOTS] Appending to snapshot: $most_recent_snapshot...";

    yarn dump:devnet --blocks $most_recent_snapshot

    notify "[SNAPSHOTS] Done.";
}

snapshot_purge()
{
    #TODO: Purge older snapshots according to snapshots_retain setting
    cd ~/.local/share/ark-core/devnet/snapshots

    # delete all but the 10 recent snapshots
    # ls -t | tail -n 1 | xargs rm -r
}