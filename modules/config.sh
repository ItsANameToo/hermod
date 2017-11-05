#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

setup_environment()
{
    if [ ! -f "$directory_noah/.noah" ]; then
        cp "$directory_noah/.noah.example" "$directory_noah/.noah"
    fi

    if [[ -e "$directory_noah/.noah" ]]; then
        . "$directory_noah/.noah"
    fi
}

check_configuration()
{
    # if [[ -z $(command -v jq) ]]; then
    #     abort 1 'jq is not installed. Please install it first.'
    # fi

    # if [[ -z $(command -v pm2) ]]; then
    #     abort 1 'pm2 is not installed. Please install it first.'
    # fi

    if [[ $network != 'mainnet' || $network != 'devnet' ]]; then
        abort 1 'Please setup the network.'
    fi
}
