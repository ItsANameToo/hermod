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
    local target="${directory_snapshot}/current";

    if [[ -e $target ]]; then
        rm ${target}
    fi

    wget -nv ${snapshot} -O ${target} &> /dev/null
}

snapshot_restore()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    pg_restore -O -j 8 -d ark_${network} ${directory_snapshot}/current &> /dev/null
}
