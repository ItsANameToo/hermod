#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# -------------------------
# noah
# -------------------------

# noah=$(basename "$0")
noah_dir=$(dirname "$0")
noah_log="${noah_dir}/noah.log"

# -------------------------
# ARK
# -------------------------

ark_dir=$(locate -b '\ark-node')                       # ark-node directory...
ark_log=${ark_dir}/logs/ark.log                        # ark-node log file...

# -------------------------
# Network
# -------------------------

network=$(cd $ark_dir && git symbolic-ref --short -q HEAD)  # network we operate on...

# -------------------------
# Snapshot
# -------------------------

snapshot_mainnet=(
    'https://snapshots.ark.io/current'
    'https://s.arkno.de/current'
    'http://s.arkx.io/current'
    'https://www.arkdelegate.com/current'
    'https://dafty.net/snapshot1/current'
    'https://dafty.net/snapshot2/current'
    'https://dafty.net/snapshot3/current'
    'https://dafty.net/snapshot4/current'
    'https://dafty.net/snapshot5/current'
    'https://dafty.net/snapshot6/current'
    'https://snapshot.arkcoin.net/current'
    'http://ark.delegate-goose.biz/snapshot/current'
)

snapshot_devnet=(
    'https://dsnapshots.ark.io/current'
)

snapshot_dir=${HOME}/snapshots                         # ark-node directory for snapshots...
