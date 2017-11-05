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
    forever stop ${process_forever} >&- 2>&-
}

node_restart()
{
    cd ${directory_ark}
    forever restart ${process_forever} >&- 2>&-
}
