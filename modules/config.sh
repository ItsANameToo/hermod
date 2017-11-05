#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

if [ ! -f "$directory_noah/.noah" ]; then
    cp "$directory_noah/.noah.example" "$directory_noah/.noah";

    error "Yikes! You have to run noah.sh install before you can get started."
fi

if [[ -e "$directory_noah/.noah" ]]; then
    . "$directory_noah/.noah"
fi
