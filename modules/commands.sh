#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

hermod_start()
{
    heading "Starting hermod..."
    pm2 start ${hermod_dir}/apps.json >> $hermod_log 2>&1
    success "Start complete!"
}

hermod_stop()
{
    heading "Stopping hermod..."
    pm2 stop ${hermod_dir}/apps.json >> $hermod_log 2>&1
    success "Stop complete!"
}

hermod_restart()
{
    heading "Restarting hermod..."
    pm2 restart ${hermod_dir}/apps.json >> $hermod_log 2>&1
    success "Restart complete!"
}

hermod_reload()
{
    heading "Reloading hermod..."
    pm2 reload ${hermod_dir}/apps.json >> $hermod_log 2>&1
    success "Reload complete!"
}

hermod_delete()
{
    heading "Deleting hermod..."
    pm2 delete ${hermod_dir}/apps.json >> $hermod_log 2>&1
    success "Delete complete!"
}

hermod_config()
{
    nano ${hermod_dir}/.hermod
}

hermod_tail()
{
    if [ ! -e $hermod_log ]; then
        touch $hermod_log
    fi

    tail -f $hermod_log
}

hermod_update()
{
    cd $hermod_dir

    local remote_version=$(git rev-parse origin/master)
    local local_version=$(git rev-parse HEAD)

    if [[ $remote_version == $local_version ]]; then
        info 'You are already using the latest version.'
    else
        read -p 'An update is available, do you want to install it? [y/N] :' choice

        if [[ $choice =~ ^(yes|y) ]]; then
            hermod_stop

            heading "Starting Update..."
            git reset --hard >> $hermod_log 2>&1
            git pull >> $hermod_log 2>&1
            success 'Update OK!'

            hermod_start
        fi
    fi
}

hermod_test()
{
    heading "Starting Test..."
    $1 "$2"
    success "Test complete!"
}

hermod_alias()
{
    heading "Installing alias..."
    echo "alias hermod='bash ${hermod_dir}/hermod.sh'" | tee -a ${HOME}/.bashrc
    source ${HOME}/.bashrc
    success "Installation complete!"
}

hermod_version()
{
    echo $(git rev-parse HEAD)
}

hermod_help()
{
    cat << EOF
Usage: $hermod [options]
options:
    help                      Show this help.
    version                   Show the installed version.
    start                     Start the hermod process.
    stop                      Stop the hermod process.
    restart                   Restart the hermod process.
    reload                    Reload the hermod process.
    delete                    Delete the hermod process.
    monitor                   Temporarily monitor the log.
    install                   Setup hermod interactively.
    update                    Update the hermod installation.
    config                    Configure the hermod installation.
    log                       Show the hermod log.
    test [method] [params]    Test the specified method.
    alias                     Create a bash alias for hermod.
EOF
}
