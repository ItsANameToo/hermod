#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

rebuild_via_monitor()
{
    if [[ $trigger_method_notify = true ]]; then
        notify "Starting Rebuild"
    fi

    if [[ $trigger_method_notify = true ]]; then
        notify "Stopping ARK Process"
    fi

    ark_stop

    if [[ $trigger_method_notify = true ]]; then
        notify "Dropping Database Connections"
    fi

    database_close

    if [[ $trigger_method_notify = true ]]; then
        notify "Dropping Database"
    fi

    database_destroy

    if [[ $trigger_method_notify = true ]]; then
        notify "Dropping Database User"
    fi

    database_drop_user

    if [[ $trigger_method_notify = true ]]; then
        notify "Creating Database"
    fi

    database_create

    if [[ $trigger_method_notify = true ]]; then
        notify "Choosing Snapshot"
    fi

    snapshot_choose

    if [[ $trigger_method_notify = true ]]; then
        notify "Downloading Snapshot"
    fi

    snapshot_download

    if [[ $trigger_method_notify = true ]]; then
        notify "Restoring Database"
    fi

    snapshot_restore

    if [[ $trigger_method_notify = true ]]; then
        notify "Restarting Database"
    fi

    database_restart

    if [[ $trigger_method_notify = true ]]; then
        notify "Starting ARK Process"
    fi

    ark_start

    if [[ $trigger_method_notify = true ]]; then
        notify "Rebuild completed!"
    fi
}

rebuild_via_command()
{
    heading "Starting Rebuild"

    noah_stop

    info "Stopping ARK Process"
    ark_stop

    info "Dropping Database Connections"
    database_close

    info "Dropping Database"
    database_destroy

    info "Dropping Database User"
    database_drop_user

    info "Creating Database"
    database_create

    info "Choosing Snapshot"
    snapshot_choose

    info "Downloading Snapshot"
    snapshot_download

    info "Restoring Database"
    snapshot_restore

    info "Restarting Database"
    database_restart

    info "Starting ARK Process"
    ark_start

    success "Rebuild completed!"
}
