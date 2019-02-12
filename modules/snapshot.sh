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
    # # make sure postgres is running
    # process_postgres=$(pgrep -a postgres | awk '{print $1}')

    # if [ -z "$process_postgres" ]; then
    #     sudo service postgresql start
    # fi

    # go into the snapshot dir
    cd ~/.local/share/ark-core/devnet/snapshots

    # check if dir is empty
    has_snapshots=$(ls -1 . | wc -l)

    if [ $has_snapshots -gt 0 ] 
    then
        snapshot_dump
    else
        snapshot_append
    fi

    # # delete all but the 10 recent snapshots
    # ls -t | tail -n +$snapshot_amount | xargs rm --

    # # check if we send the snapshot to a remote location
    # if [[ $snapshot_remote = true ]]; then
    #     rsync --checksum --no-whole-file -v -e "ssh -p ${snapshot_remote_port} -i ${snapshot_remote_identity_file}" current "${snapshot_remote_user}@${snapshot_remote_host}:${snapshot_remote_directory}"
    # fi
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

    notify "[SNAPSHOTS] Appending to snapshot: ${most_recent_snapshot}...";

    yarn dump:devnet --blocks $most_recent_snapshot
}