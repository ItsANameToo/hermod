#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

node_start()
{
    cd ${directory_ark}
    forever start app.js --genesis genesisBlock.${network}.json --config config.${network}.json >&- 2>&-
}

node_stop()
{
    cd ${directory_ark}
    forever stopall # We use pm2 so we can stop all forever processes (prevent duplication)
    # forever stop ${process_forever} >&- 2>&-
}
