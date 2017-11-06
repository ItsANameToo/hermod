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
    if [[ $network != 'mainnet' && $network != 'devnet' ]]; then
        abort 1 "network [$network] is invalid."
    fi

    if [[ ! -e $ark_log ]];then
        abort 1 "ark_log [$ark_log] does not exist."
    fi

    if [[ ! -r $ark_log ]];then
        abort 1 "ark_log [$ark_log] is not readable."
    fi

    if (($monitor_lines <= 0)); then
        abort 1 "monitor_lines [$monitor_lines] has to be greater than 0."
    fi

    if (($monitor_rebuild <= 0)); then
        abort 1 "monitor_rebuild [$monitor_rebuild] has to be greater than 0."
    fi

    if (($monitor_interval <= 0)); then
        abort 1 "monitor_interval [$monitor_interval] has to be greater than 0."
    fi

    if (($relay_port <= 0)); then
        abort 1 "relay_port [$relay_port] has to be greater than 0."
    fi
}
