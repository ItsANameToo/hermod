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

parse_args()
{
    case "$1" in
        start)
            process_vars

            hermod_start
        ;;
        stop)
            hermod_stop
        ;;
        restart)
            hermod_restart
        ;;
        reload)
            hermod_reload
        ;;
        delete)
            hermod_delete
        ;;
        monitor)
            process_vars

            monitor
        ;;
        install)
            hermod_install
        ;;
        update)
            hermod_update
        ;;
        config)
            hermod_config
        ;;
        log)
            hermod_tail
        ;;
        alias)
            hermod_alias
        ;;
        test)
            hermod_test "$2" "$3"
        ;;
        version)
            hermod_version

            exit 1
        ;;
        snapshot)
            hermod_snapshot

            exit 1
        ;;
        rollback)
            hermod_rollback

            exit 1
        ;;
        share)
            hermod_share

            exit 1
        ;;
        help|*)
            hermod_help

            exit 1
        ;;
    esac
}
