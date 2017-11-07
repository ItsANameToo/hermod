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
}
