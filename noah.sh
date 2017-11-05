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
# Modules
# -------------------------

. modules/bootstrap.sh
. modules/colors.sh
. modules/config.sh
. modules/night-mode.sh
. modules/node.sh
. modules/processes.sh
. modules/notifications.sh
. modules/database.sh
. modules/snapshot.sh
. modules/rebuild.sh
. modules/relay.sh
. modules/monitor.sh
. modules/commands.sh

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
