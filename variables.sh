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
# ARK
# -------------------------

ark_dir=$(locate -b '\ark-node')
ark_log=${ark_dir}/logs/ark.log

# -------------------------
# Network
# -------------------------

network=$(cd $ark_dir && git symbolic-ref --short -q HEAD)

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
    'http://s.arkmoon.com/current'
    'http://arkdel.net/current'
)

snapshot_devnet=(
    'https://dsnapshots.ark.io/current'
    'https://dsnapshot.arkno.de/current'
    'http://dexplorer.ark.land/snapshots/current'
)

snapshot_dir=${HOME}/snapshots
