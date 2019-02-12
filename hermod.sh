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

# -------------------------
# Variables
# -------------------------

hermod=$(basename "$0")
hermod_dir="${HOME}/hermod"
hermod_log="${hermod_dir}/hermod.log"

# -------------------------
# Modules
# -------------------------

. "${hermod_dir}/modules/colors.sh"
. "${hermod_dir}/modules/errors.sh"
. "${hermod_dir}/modules/bootstrap.sh"
. "${hermod_dir}/modules/config.sh"
. "${hermod_dir}/variables.sh"
. "${hermod_dir}/modules/processes.sh"
. "${hermod_dir}/modules/notifications.sh"
. "${hermod_dir}/modules/monitor.sh"
. "${hermod_dir}/modules/snapshot.sh"
. "${hermod_dir}/modules/commands.sh"
. "${hermod_dir}/modules/install.sh"
. "${hermod_dir}/modules/args.sh"

# -------------------------
# Start
# -------------------------

main()
{
    setup_environment
    check_configuration

    parse_args "$@"

    trap cleanup SIGINT SIGTERM SIGKILL
}

main "$@"
