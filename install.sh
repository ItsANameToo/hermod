# --------------------------------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------------------------------

DIRECTORY_NOAH="$HOME/noah"

if [ ! -f "$DIRECTORY_NOAH/noah.conf" ]; then
    echo "Setup Configuration..."
    cp "$DIRECTORY_NOAH/noah.conf.example" "$DIRECTORY_NOAH/noah.conf";
else
    echo "Configuration already exists..."
fi

# --------------------------------------------------------------------------------------------------
# Visudo
# --------------------------------------------------------------------------------------------------

echo "Setup visudo..."
echo 'ark ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
