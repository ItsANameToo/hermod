#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

noah_start()
{
    heading "Starting noah..."
    pm2 start "$directory_noah/noah.sh" --interpreter="bash" -- monitor >> "$directory_noah_logs/pm2.log" 2>&1
    success "Start complete!"
}

noah_stop()
{
    heading "Stopping noah..."
    pm2 stop "$directory_noah/noah.sh" >> "$directory_noah_logs/pm2.log" 2>&1
    success "Stop complete!"
}

noah_restart()
{
    heading "Restarting noah..."
    pm2 restart "$directory_noah/noah.sh" --interpreter="bash" -- monitor >> "$directory_noah_logs/pm2.log" 2>&1
    success "Restart complete!"
}

noah_log()
{
    if [ ! -f $file_noah_log ]; then
        touch $file_noah_log
    fi

    tail -f $file_noah_log
}

noah_update()
{
    heading "Starting Update..."
    git reset --hard >> "$directory_noah_logs/update.log" 2>&1
    git pull >> "$directory_noah_logs/update.log" 2>&1
    success "Update complete!"
}

noah_alias()
{
    heading "Installing alias..."
    echo "alias noah='bash ~/noah/noah.sh'" | tee -a ~/.bashrc
    source ~/.bashrc
    success "Installation complete!"
}

noah_version()
{
    echo $(cat "$directory_noah/version")
}

noah_help()
{
    cat << EOF
Usage: $me [options]
options:
    help                      Show this help.
    version                   Show this version.
    start                     Start the noah process.
    stop                      Stop the noah process.
    restart                   Restart the noah process.
    rebuild                   Start the rebuild process.
    monitor                   Temporarily monitor the log.
    install                   Setup noah interactively.
    update                    Update the noah installation.
    log                       Show the noah log.
    test [method] [params]    Test the specified method.
    alias                     Create a bash alias for noah.
EOF
}
