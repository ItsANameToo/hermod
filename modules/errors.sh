#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

abort()
{
    error "Yikes! $2" >> $noah_log 2>&1
    exit $1
}

log()
{
    echo "$1" >> $noah_log 2>&1
}
