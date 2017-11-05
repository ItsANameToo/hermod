#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

directory_noah=$(dirname $0)

# -------------------------
# Modules
# -------------------------

. "$directory_noah/modules/colors.sh"
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

# -------------------------
# Parse Arguments
# -------------------------

case "$1" in
    start)
        noah_start
    ;;
    stop)
        noah_stop
    ;;
    restart)
        noah_restart
    ;;
    rebuild)
        process_vars

        rebuild_via_command
    ;;
    monitor)
        process_vars

        monitor
    ;;
    install)
        noah_install
    ;;
    update)
        noah_update
    ;;
    log)
        noah_log
    ;;
    alias)
        noah_alias
    ;;
    test)
        heading "Starting Test..."
        $2 "$3"
        success "Test complete!"
    ;;
    version)
        noah_version
        exit 1
    ;;
    help|*)
        noah_help
        exit 1
    ;;
esac
