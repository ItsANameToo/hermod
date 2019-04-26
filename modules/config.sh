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

        warning "hermod has been installed and a default configuration was created. Next, you need to run 'bash hermod.sh config' to edit the default values."
    fi

    if [[ -e ${hermod_dir}/.hermod ]]; then
        . ${hermod_dir}/.hermod
    fi
}

check_configuration()
{

    log_files=("${core_log_path}/*.log")
    if [ ! -e ${log_files[0]} ]; then
        abort 1 "log file in specified folder [$core_log_path] does not exist"
    fi

    if [[ $core_network != 'mainnet' && $core_network != 'devnet' ]]; then
        abort 1 "core_network [$core_network] is invalid."
    fi

    if [ -z "$core_processes" ]; then
        abort 1 "core_processes should not be empty."
    fi

    if (($core_processes != 1 && $core_processes != 2)); then
        abort 1 "core_processes [$core_processes] has to be set to 1 or 2."
    fi

    if (($monitor_lines <= 0)); then
        abort 1 "monitor_lines [$monitor_lines] has to be greater than 0."
    fi

    if (($monitor_interval <= 0)); then
        abort 1 "monitor_interval [$monitor_interval] has to be greater than 0."
    fi

    if (($monitor_sleep_after_notif <= 0)); then
        abort 1 "monitor_sleep_after_notif [$monitor_sleep_after_notif] has to be greater than 0."
    fi

    if (($monitor_sleep_halted <= 0)); then
        abort 1 "monitor_sleep_halted [$monitor_sleep_halted] has to be greater than 0."
    fi

    if (($monitor_lines_halted <= 0)); then
        abort 1 "monitor_lines_halted [$monitor_lines_halted] has to be greater than 0."
    fi

    if [ -z "$delegate_username" ]; then
        abort 1 "delegate_username should not be empty."
    fi

    if [ -z "$delegate_public_key" ]; then
        abort 1 "delegate_public_key should not be empty."
    fi
}
