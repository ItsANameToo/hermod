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
        config)
            noah_config
        ;;
        log)
            noah_tail
        ;;
        alias)
            noah_alias
        ;;
        test)
            noah_test "$2" "$3"
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
}
