#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

noah_install()
{
    heading "Starting Installation..."

    if [ -f "$directory_noah/.noah" ]; then
        info "Configuration already exists..."
    else
        heading "Installing Configuration..."
        cp "$directory_noah/.noah.example" "$directory_noah/.noah";
        success "Installation OK."
    fi

    if sudo -l | grep -q "(ALL) NOPASSWD: ALL"; then
        info "visudo already exists..."
    else
        heading "Installing visudo..."
        echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo &> /dev/null
        success "Installation OK."
    fi

    if ! [ -x "$(command -v jq)" ]; then
        heading "Installing jq..."
        sudo apt-get -qq install jq
        success "Installation OK."
    else
        info "jq already exists..."
    fi

    if ! [ -x "$(command -v pm2)" ]; then
        heading "Installing pm2..."
        npm install pm2 -g &> /dev/null
        success "Installation OK."
    else
        info "pm2 already exists..."
    fi

    success "Installation complete!"
}
