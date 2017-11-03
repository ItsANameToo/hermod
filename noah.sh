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
# Requirements
# -------------------------

if [[ $BASH_VERSINFO < 4 ]]; then
    echo "Sorry, you need at least bash-4.0 to run this script."
    exit 1
fi

# -------------------------
# Initialization
# -------------------------

PATH="$HOME/.nvm/versions/node/v6.9.5/bin:$PATH"
export PATH

# -------------------------
# Environment
# -------------------------

user=$(whoami)

# -------------------------
# Includes
# -------------------------

. "$directory_noah/_colors.sh"

# -------------------------
# Configuration
# -------------------------

directory_noah="$HOME/noah"

if [ ! -f "$directory_noah/noah.conf" ]; then
    error "noah has not been configured. Please run noah.sh --install."
    exit 1
fi

if [[ -e "$directory_noah/noah.conf" ]]; then
    . "$directory_noah/noah.conf"
fi

# -------------------------
# Night Mode
# -------------------------

trigger_method_notify=true  # notify if we have a match in the log...
trigger_method_rebuild=true # rebuild if we have a match in the log...

if [[ $night_mode_enabled = true ]]; then
    night_mode_current_hour=$(date +"%H")

    if [ ${night_mode_current_hour} -ge ${night_mode_end} -a ${night_mode_current_hour} -le ${night_mode_start} ]; then
        # Day
        trigger_method_notify=true
        trigger_method_rebuild=false
    else
        # Night
        trigger_method_notify=false
        trigger_method_rebuild=true
    fi
fi

# -------------------------
# Grab Processes
# -------------------------

process_postgres=$(pgrep -a "postgres" | awk '{print $1}')
process_ark_node=$(pgrep -a "node" | grep ark-node | awk '{print $1}')

if [ -z "$process_ark_node" ]; then
    node_start
fi

process_forever=$(forever --plain list | grep ${process_ark_node} | sed -nr 's/.*\[(.*)\].*/\1/p')

# -------------------------
# Functions
# -------------------------

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

notify_via_log()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    printf "[$current_datetime] $1\n" >> $notification_log
}

notify_via_email()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$current_datetime] $1" | mail -s "$notification_email_subject" "$notification_email_to"
}

notify_via_nexmo()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    curl -X "POST" "https://rest.nexmo.com/sms/json" \
      -d "from=$notification_nexmo_from" \
      -d "text=[$current_datetime] $1" \
      -d "to=$notification_nexmo_to" \
      -d "api_key=$notification_nexmo_api_key" \
      -d "api_secret=$notification_nexmo_api_secret"
}

notify_via_pushover()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    curl -s -F "token=$notification_pushover_token" \
        -F "user=$notification_pushover_user" \
        -F "title=$notification_pushover_title" \
        -F "message=[$current_datetime] $1" https://api.pushover.net/1/messages.json
}

notify_via_pushbullet()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    curl --header "Access-Token: $notification_pushbullet_access_token" \
         --header 'Content-Type: application/json' \
         --data-binary "{\"body\":\"[$current_datetime] $1\",\"title\":\"$notification_pushbullet_title\",\"type\":\"note\"}" \
         --request POST \
         https://api.pushbullet.com/v2/pushes
}

notify_via_mailgun()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    curl -s --user "api:$notifications_mailgun_api_key" \
        "https://api.mailgun.net/v3/$notifications_mailgun_domain/messages" \
        -F from="$notifications_mailgun_from <mailgun@$notifications_mailgun_domain>" \
        -F to="$notifications_mailgun_to" \
        -F subject="$notifications_mailgun_subject" \
        -F text="[$current_datetime] $1"
}

notify_via_slack()
{
    local current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$current_datetime] $1" | $notification_slack_slacktee -c "$notification_slack_channel" -u "$notification_slack_from" -i "$notification_slack_icon"
}

notify()
{
    for driver in "${notification_driver[@]}"
    do
        case $driver in
            log)
                notify_via_log "$1"
            ;;
            email)
                notify_via_email "$1"
            ;;
            nexmo)
                notify_via_nexmo "$1"
            ;;
            slack)
                notify_via_slack "$1"
            ;;
            pushover)
                notify_via_pushover "$1"
            ;;
            pushbullet)
                notify_via_pushbullet "$1"
            ;;
            mailgun)
                notify_via_mailgun "$1"
            ;;
            none)
                :
            ;;
            *)
                notify_via_log "$1"
            ;;
        esac
    done
}

database_drop_user()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    sudo -u postgres dropuser --if-exists $user
}

database_destroy()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    dropdb --if-exists ark_${network}
}

database_create()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    sleep 1
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';" >&- 2>&-
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';" >&- 2>&-
    sudo -u postgres psql -c "CREATE USER $user WITH PASSWORD 'password' CREATEDB;" >&- 2>&-
    sleep 1
    createdb ark_${network}
}

snapshot_download()
{
    rm ${directory_snapshot}/current
    wget -nv ${snapshot_source} -O ${directory_snapshot}/current &> /dev/null
}

snapshot_restore()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    pg_restore -O -j 8 -d ark_${network} ${directory_snapshot}/current &> /dev/null
}

rebuild()
{
    heading "Starting Rebuild..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Starting Rebuild..."
    fi

    info "Stopping ARK Process..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Stopping ARK Process..."
    fi

    node_stop

    info "Dropping Database User..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Dropping Database User..."
    fi

    database_destroy

    info "Dropping Database..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Dropping Database..."
    fi

    database_drop_user

    info "Creating Database..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Creating Database..."
    fi

    database_create

    info "Downloading Current Snapshot..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Downloading Current Snapshot..."
    fi

    snapshot_download

    info "Restoring Database..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Restoring Database..."
    fi

    snapshot_restore

    info "Starting ARK Process..."

    if [[ $trigger_method_notify = true ]]; then
        notify "Starting ARK Process..."
    fi

    node_start

    success "Rebuild completed!"

    if [[ $trigger_method_notify = true ]]; then
        notify "Rebuild completed!"
    fi
}

observe()
{
    heading "Starting Observer..."

    while true; do
        if tail -n $observe_lines $file_ark_log | grep -q "Blockchain not ready to receive block"; then
            # Day >>> Only Notify
            if [[ $trigger_method_notify = true && $trigger_method_rebuild = false ]]; then
                notify "ARK Node out of sync - Rebuild required...";
            fi

            # Night >>> Only Rebuild
            if [[ $trigger_method_rebuild = true ]]; then
                rebuild
            fi

            sleep $wait_between_rebuild

            break
        fi

        # Reduce CPU Overhead
        sleep $wait_between_log_check
    done
}

noah_start()
{
    heading "Starting noah..."
    forever start --pidFile "$directory_noah/noah.pid" -c bash "$directory_noah/noah.sh" -o &> /dev/null
    success "Start complete!"
}

noah_stop()
{
    heading "Stopping noah..."
    forever stop "$directory_noah/noah.sh" &> /dev/null
    success "Stop complete!"
}

noah_restart()
{
    heading "Restarting noah..."
    forever restart --pidFile "$directory_noah/noah.pid" -c bash "$directory_noah/noah.sh" -o &> /dev/null
    success "Restart complete!"
}

noah_log()
{
    tail -f $file_noah_log
}

noah_install()
{
    heading "Starting Installation..."

    [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

    heading "Installing Configuration..."
    if [ ! -f "$directory_noah/noah.conf" ]; then
        cp "$directory_noah/noah.conf.example" "$directory_noah/noah.conf";
    else
        info "Configuration already exists..."
    fi
    success "Installed OK."

    heading "Installing visudo..."
    echo "$user ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo &> /dev/null
    success "Installed OK."

    # heading "Installing pm2..."
    # npm list -g | grep pm2
    # npm install pm2 -g
    # success "Installed OK."

    success "Installation complete!"
}

noah_update()
{
    heading "Starting Update..."
    git reset --hard && git pull &> /dev/null
    success "Update complete!"
}

noah_alias()
{
    heading "Installing alias..."
    echo "alias noah='bash ~/noah/noah.sh'" | tee -a ~/.bashrc
    source ~/.bashrc
    success "Installation complete!"
}

noah_help()
{
	local me=$(basename "$0")

    cat << EOF
Usage: $me [options]
options:
    -h, --help, --pray              Show this help.
    -b, --start, --board            Start the noah process.
    -m, --stop, --martyr            Stop the noah process.
    -f, --restart, --flood          Restart the noah process.
    -r, --rebuild, --rebirth        Start the rebuild process.
    -o, --observe, --guard          Temporarily observe the log.
    -i, --install                   Setup noah interactively.
    -u, --update                    Update the noah installation.
    -l, --log                       Show the noah log.
    -t, --test [method] [params]    Test the specified method.
    -a, --alias                     Create a bash alias for noah.
EOF
}

# -------------------------
# Parse Arguments
# -------------------------

case "$1" in
    -b|--start|--board)
        noah_start
    ;;
    -m|--stop|--martyr)
        noah_stop
    ;;
    -f|--restart|--flood)
        noah_restart
    ;;
    -r|--rebuild|--rebirth)
        rebuild
    ;;
    -o|--observe|--pray)
        observe
    ;;
    -i|--install)
        noah_install
    ;;
    -u|--update)
        noah_update
    ;;
    -l|--log)
        noah_log
    ;;
    -a|--alias)
        noah_alias
    ;;
    -t|--test)
        heading "Starting Test..."
        $2 "$3"
        success "Test complete!"
    ;;
    -h|\?|--help|*)
        noah_help
        exit 1
    ;;
esac
