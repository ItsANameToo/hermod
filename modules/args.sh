#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

parse_args()
{
    case "$1" in
        start)
            noah_update

            process_vars

            noah_start
        ;;
        stop)
            noah_update

            noah_stop
        ;;
        restart)
            noah_update

            noah_restart
        ;;
        reload)
            noah_update

            noah_reload
        ;;
        delete)
            noah_delete
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
        config)
            noah_update

            noah_config
        ;;
        log)
            noah_update

            noah_tail
        ;;
        alias)
            noah_update

            noah_alias
        ;;
        test)
            noah_update

            noah_test "$2" "$3"
        ;;
        version)
            noah_update

            noah_version

            exit 1
        ;;
        help|*)
            noah_update

            noah_help

            exit 1
        ;;
    esac
}
