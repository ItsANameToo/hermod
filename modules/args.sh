#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# TODO: change these args
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
        help|*)
            hermod_help

            exit 1
        ;;
    esac
}
