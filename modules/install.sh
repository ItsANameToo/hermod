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

    heading "Installing Configuration..."
    if [ -f "$directory_noah/.noah" ]; then
        info "Configuration already exists..."
    else
        cp "$directory_noah/.noah.example" "$directory_noah/.noah";
    fi
    success "Installation OK."

    heading "Installing visudo..."
    if sudo -l | grep -q "(ALL) NOPASSWD: ALL"; then
        info "visudo already exists..."
    else
        echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo &> /dev/null
    fi
    success "Installation OK."

    heading "Installing jq..."
    jq=$(type jq &> /dev/null)

    if [ -z "$jq" ]; then
        sudo apt-get -qq install jq
    else
        info "jq already exists..."
    fi
    success "Installation OK."

    heading "Installing pm2..."
    pm2=$(type pm2 &> /dev/null)

    if [ -z "$pm2" ]; then
        npm install pm2 -g &> /dev/null
    else
        info "pm2 already exists..."
    fi
    success "Installation OK."

    success "Installation complete!"
}
