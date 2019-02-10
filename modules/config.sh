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

setup_environment()
{
    if [ ! -f ${hermod_dir}/.hermod ]; then
        cp ${hermod_dir}/.hermod.example ${hermod_dir}/.hermod

        warning "Yikes! A default configuration has been created, next you need to run the install command to get started."
    fi

    if [[ -e ${hermod_dir}/.hermod ]]; then
        . ${hermod_dir}/.hermod
    fi
}

check_configuration()
{
    # TODO: check if log file exists and is readable

    if (($monitor_lines <= 0)); then
        abort 1 "monitor_lines [$monitor_lines] has to be greater than 0."
    fi

    if (($monitor_interval <= 0)); then
        abort 1 "monitor_interval [$monitor_interval] has to be greater than 0."
    fi
}
