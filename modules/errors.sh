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

abort()
{
    echo "Error: $2" >&2 # Print to stderr
    error "Yikes! $2" >> $hermod_log 2>&1
    exit $1
}

log()
{
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')
        
    printf "[$datetime] $1\n" >> $hermod_log
}