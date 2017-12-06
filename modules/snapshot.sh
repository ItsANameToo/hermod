#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

snapshot=""

snapshot_download()
{
    local target=${snapshot_dir}/current

    if [[ -e $target ]]; then
        rm -f ${target} >> $noah_log 2>&1
    fi

    wget -nv ${snapshot} -O ${target} >> $noah_log 2>&1
}

snapshot_restore()
{
    pg_restore -n public -O -j 8 -d ark_${network} ${snapshot_dir}/current >> $noah_log 2>&1

    # temporary fix to add index - https://github.com/ArkEcosystem/ark-node/pull/47
    sudo -u postgres psql -d ark_${network} -c 'CREATE INDEX IF NOT EXISTS "mem_accounts2delegates_dependentId" ON mem_accounts2delegates ("dependentId");'
}

snapshot_choose()
{
    # initial determination of what snapshot to use
    if [ "$network" == 'mainnet' ]; then
        snapshot=${snapshot_mainnet[$RANDOM % ${#snapshot_mainnet[@]}]}
    else
        snapshot=${snapshot_devnet[$RANDOM % ${#snapshot_devnet[@]}]}
    fi

    # prevent the use of the same snapshot twice in a row
    local snapshot_previous_log="${noah_dir}/data/snapshot.txt"
    local snapshot_previous=$(cat $snapshot_previous_log)

    while [ "$snapshot" == "$snapshot_previous" ]; do
        if [ "$network" == 'mainnet' ]; then
            snapshot=${snapshot_mainnet[$RANDOM % ${#snapshot_mainnet[@]}]}
        else
            snapshot=${snapshot_devnet[$RANDOM % ${#snapshot_devnet[@]}]}
        fi
    done

    # choose a new snapshot until it exists
    until $(curl "$snapshot" --silent --head --fail --output /dev/null); do
        snapshot_choose
    done
    
    # choose a new snapshot until it exceeds 0MB
    until [[ $(curl -sI $snapshot | wc -c) -gt 0 ]]; do
        snapshot_choose
    done

    # store the current snapshot url
    echo "$snapshot" > $snapshot_previous_log

    # log which snapshot we chose
    echo "Chose ${snapshot}..." >> $noah_log 2>&1
}
