#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# -------------------------
# Variables
# -------------------------

noah=$(basename "$0")
noah_dir="${HOME}/noah"
noah_log="${noah_dir}/noah.log"
. "${noah_dir}/variables.sh"

# -------------------------
# Modules
# -------------------------

. "${noah_dir}/modules/colors.sh"
. "${noah_dir}/modules/errors.sh"
. "${noah_dir}/modules/bootstrap.sh"
. "${noah_dir}/modules/config.sh"
. "${noah_dir}/modules/processes.sh"
. "${noah_dir}/modules/notifications.sh"
. "${noah_dir}/modules/monitor.sh"
. "${noah_dir}/modules/commands.sh"
. "${noah_dir}/modules/install.sh"
. "${noah_dir}/modules/args.sh"

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
