#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
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

snapshot_dir=${HOME}/snapshots
