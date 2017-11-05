#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

me=$(basename "$0")
directory_noah=$(dirname "$0")

# -------------------------
# Modules
# -------------------------

. "$directory_noah/modules/colors.sh"
. "$directory_noah/modules/errors.sh"
. "$directory_noah/modules/bootstrap.sh"
. "$directory_noah/modules/config.sh"
. "$directory_noah/modules/night-mode.sh"
. "$directory_noah/modules/node.sh"
. "$directory_noah/modules/processes.sh"
. "$directory_noah/modules/notifications.sh"
. "$directory_noah/modules/database.sh"
. "$directory_noah/modules/snapshot.sh"
. "$directory_noah/modules/rebuild.sh"
. "$directory_noah/modules/relay.sh"
. "$directory_noah/modules/monitor.sh"
. "$directory_noah/modules/commands.sh"
. "$directory_noah/modules/install.sh"
. "$directory_noah/modules/args.sh"

# -------------------------
# Start
# -------------------------

function main()
{
    setup_environment
    check_configuration

    parse_args "$@"

    trap cleanup SIGINT SIGTERM SIGKILL
}

main "$@"
