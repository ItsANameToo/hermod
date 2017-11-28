#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

snapshot_download()
{
    local target=${snapshot_dir}/current

    # initial determination of what snapshot to use
    local snapshot=""

    if [ "$network" == 'mainnet' ]; then
        snapshot=${snapshot_mainnet[$RANDOM % ${#snapshot_mainnet[@]}]}
    else
        snapshot=${snapshot_devnet[$RANDOM % ${#snapshot_devnet[@]}]}
    fi

    # prevent the use of the same snapshot twice in a row
    local snapshot_previous_log="${noah_dir}/data/snapshot.txt"
    local snapshot_previous=$(cat $snapshot_previous_log)

    while [ "$snapshot_previous" == "$snapshot" ]; do
        if [ "$network" == 'mainnet' ]; then
            snapshot=${snapshot_mainnet[$RANDOM % ${#snapshot_mainnet[@]}]}
        else
            snapshot=${snapshot_devnet[$RANDOM % ${#snapshot_devnet[@]}]}
        fi
    done

    # store the current snapshot url
    echo "$snapshot" > $snapshot_previous_log

    if [ ! -f $target ]; then
        wget -nv ${snapshot} -O ${target} >> $noah_log 2>&1
    else
        if [[ $(expr `date +%s` - `stat -c %Y $target`) -gt 900 ]]; then
            if [[ -e $target ]]; then
                rm -f ${target} >> $noah_log 2>&1
            fi

            wget -nv ${snapshot} -O ${target} >> $noah_log 2>&1
        fi
    fi
}

snapshot_restore()
{
    pg_restore -O -j 8 -d ark_${network} ${snapshot_dir}/current >> $noah_log 2>&1

    # temporary fix to add index - https://github.com/ArkEcosystem/ark-node/pull/47
    sudo -u postgres psql -d ark_${network} -c 'CREATE INDEX IF NOT EXISTS "mem_accounts2delegates_dependentId" ON mem_accounts2delegates ("dependentId");'
}
