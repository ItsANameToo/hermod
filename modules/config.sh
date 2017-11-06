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
    if [ ! -f ${noah_dir}/.noah ]; then
        cp ${noah_dir}/.noah.example ${noah_dir}/.noah

        warning "Yikes! A default configuration has been created, next you need to run the install command to get started."
    fi

    if [[ -e ${noah_dir}/.noah ]]; then
        . ${noah_dir}/.noah
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

    if [[ $network != 'mainnet' && $network != 'devnet' ]]; then
        abort 1 "$network is invalid."
    fi

    if [[ ! -e $ark_log ]];then
        abort 1 "$ark_log does not exist."
    fi

    if [[ ! -r $ark_log ]];then
        abort 1 "$ark_log is not readable."
    fi
}
