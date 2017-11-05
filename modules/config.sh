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
fi

if [[ -e "$directory_noah/.noah" ]]; then
    . "$directory_noah/.noah"
fi
