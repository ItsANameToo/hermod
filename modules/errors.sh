#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

abort()
{
    error "Yikes! $2" >> $hermod_log 2>&1
    exit $1
}

log()
{
    echo "$1" >> $hermod_log 2>&1
}
