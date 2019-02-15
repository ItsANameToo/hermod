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

hermod_install()
{
    heading "Starting Installation..."

    if [ -f ${hermod_dir}/.hermod ]; then
        info "Configuration already exists..."
    else
        heading "Installing Configuration..."
        cp ${hermod_dir}/.hermod.example ${hermod_dir}/.hermod;
        success "Installation OK."
    fi

    if sudo -l | grep -q "(ALL) NOPASSWD: ALL"; then
        info "visudo already exists..."
    else
        heading "Installing visudo..."
        echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo >> $hermod_log 2>&1
        success "Installation OK."
    fi

    if [[ -z $(command -v jq) ]]; then
        heading "Installing jq..."
        sudo apt-get -qq install jq >> $hermod_log 2>&1
        success "Installation OK."
    else
        info "jq already exists..."
    fi

    if [[ -z $(command -v pm2) ]]; then
        heading "Installing pm2..."
        npm install pm2 -g >> $hermod_log 2>&1
        success "Installation OK."
    else
        info "pm2 already exists..."
    fi

    success "Installation complete!"
}
