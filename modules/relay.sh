#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!! NOT FULLY TESTED - USE AT YOUR OWN RISK !!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

rebuild_with_relay()
{
    local config=${ark_dir}/config.${network}.json
    local relay="-p ${relay_port} ${relay_user}@${relay_ip}"

    # disable forging node...
    info "Disable Forging Node"

    if [[ $trigger_method_notify = true ]]; then
        notify "Disable Forging Node"
    fi

    jq '.forging.secret = []' <<< cat $config > tmp.$$.json && mv tmp.$$.json $config
    ark_stop
    sleep 2

    # enable relay node...
    info "Enable Relay Node"

    if [[ $trigger_method_notify = true ]]; then
        notify "Enable Relay Node"
    fi

    ssh ${relay} "jq '.forging.secret = [\"$relay_secret\"]' <<< cat $config > tmp.$$.json && mv tmp.$$.json $config"
    ssh ${relay} 'PATH="$HOME/.nvm/versions/node/v6.9.5/bin:$PATH"; export PATH; forever stopall; cd '$ark_dir'; forever start app.js --genesis genesisBlock.${network}.json --config config.${network}.json >&- 2>&-'

    # rebuild forging node...
    rebuild

    # enable forging node...
    info "Enable Forging Node"

    if [[ $trigger_method_notify = true ]]; then
        notify "Enable Forging Node"
    fi

    ark_stop
    sleep 2
    jq ".forging.secret = [\"$relay_secret\"]" <<< cat $config > tmp.$$.json && mv tmp.$$.json $config
    ark_start

    # disable relay node...
    info "Disable Relay Node"

    if [[ $trigger_method_notify = true ]]; then
        notify "Disable Relay Node"
    fi

    ssh ${relay} "jq '.forging.secret = []' <<< cat $config > tmp.$$.json && mv tmp.$$.json $config"
    ssh ${relay} 'PATH="$HOME/.nvm/versions/node/v6.9.5/bin:$PATH"; export PATH; forever stopall;'
}
