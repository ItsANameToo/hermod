#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

ark_start()
{
    cd $ark_dir
    forever start app.js --genesis genesisBlock.${network}.json --config config.${network}.json >> $noah_log 2>&1
}

ark_stop()
{
    forever stopall
}
