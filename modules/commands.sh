#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

# TODO: change these commands
noah_start()
{
    heading "Starting noah..."
    pm2 start ${noah_dir}/apps.json >> $noah_log 2>&1
    success "Start complete!"
}

noah_stop()
{
    heading "Stopping noah..."
    pm2 stop ${noah_dir}/apps.json >> $noah_log 2>&1
    success "Stop complete!"
}

noah_restart()
{
    heading "Restarting noah..."
    pm2 restart ${noah_dir}/apps.json >> $noah_log 2>&1
    success "Restart complete!"
}

noah_reload()
{
    heading "Reloading noah..."
    pm2 reload ${noah_dir}/apps.json >> $noah_log 2>&1
    success "Reload complete!"
}

noah_delete()
{
    heading "Deleting noah..."
    pm2 delete ${noah_dir}/apps.json >> $noah_log 2>&1
    success "Delete complete!"
}

noah_config()
{
    nano ${noah_dir}/.noah
}

noah_tail()
{
    if [ ! -e $noah_log ]; then
        touch $noah_log
    fi

    tail -f $noah_log
}

noah_update()
{
    cd $noah_dir

    local remote_version=$(git rev-parse origin/master)
    local local_version=$(git rev-parse HEAD)

    if [[ $remote_version == $local_version ]]; then
        info 'You are already using the latest version.'
    else
        read -p 'An update is available, do you want to install it? [y/N] :' choice

        if [[ $choice =~ ^(yes|y) ]]; then
            noah_stop

            heading "Starting Update..."
            git reset --hard >> $noah_log 2>&1
            git pull >> $noah_log 2>&1
            success 'Update OK!'

            noah_start
        fi
    fi
}

noah_test()
{
    heading "Starting Test..."
    $1 "$2"
    success "Test complete!"
}

noah_alias()
{
    heading "Installing alias..."
    echo "alias noah='bash ${noah_dir}/noah.sh'" | tee -a ${HOME}/.bashrc
    source ${HOME}/.bashrc
    success "Installation complete!"
}

noah_version()
{
    echo $(git rev-parse HEAD)
}

noah_help()
{
    cat << EOF
Usage: $noah [options]
options:
    help                      Show this help.
    version                   Show the installed version.
    start                     Start the noah process.
    stop                      Stop the noah process.
    restart                   Restart the noah process.
    reload                    Reload the noah process.
    delete                    Delete the noah process.
    rebuild                   Start the rebuild process.
    monitor                   Temporarily monitor the log.
    install                   Setup noah interactively.
    update                    Update the noah installation.
    config                    Configure the noah installation.
    log                       Show the noah log.
    test [method] [params]    Test the specified method.
    alias                     Create a bash alias for noah.
EOF
}
