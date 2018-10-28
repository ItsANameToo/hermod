#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

trigger_method_notify=true
trigger_method_rebuild=true

handle_night_mode()
{
    if [[ $night_mode_enabled = true ]]; then
        local hour=$(date +"%H")

        if [ ${hour} -ge ${night_mode_end} -a ${hour} -le ${night_mode_start} ]; then
            # Day
            trigger_method_notify=true
            trigger_method_rebuild=false
        else
            # Night
            trigger_method_notify=false
            trigger_method_rebuild=true
        fi
    fi
}

handle_night_mode
