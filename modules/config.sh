#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

if [ ! -f "$directory_noah/noah.conf" ]; then
    cp "$directory_noah/noah.conf.example" "$directory_noah/noah.conf";
fi

if [[ -e "$directory_noah/noah.conf" ]]; then
    . "$directory_noah/noah.conf"
fi
