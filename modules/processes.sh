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

process_vars()
{
    process_postgres=$(pgrep -a postgres | awk '{print $1}')

    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi
}
