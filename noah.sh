#!/bin/bash

# --------------------------------------------------------------------------------------------------
# Copyright (c) Brian Faust <hello@brianfaust.me>
# --------------------------------------------------------------------------------------------------

if [[ $BASH_VERSINFO < 4 ]]; then
    echo "Sorry, you need at least bash-4.0 to run this script."
    exit 1
fi

# --------------------------------------------------------------------------------------------------
# Initialization
# --------------------------------------------------------------------------------------------------

PATH="$HOME/.nvm/versions/node/v6.9.5/bin:$PATH"
export PATH

# --------------------------------------------------------------------------------------------------
# Environment
# --------------------------------------------------------------------------------------------------

USER=$(whoami)

# --------------------------------------------------------------------------------------------------
# Processes
# --------------------------------------------------------------------------------------------------

PROCESS_POSTGRES=$(pgrep -a "postgres" | awk '{print $1}')
PROCESS_NODE=$(pgrep -a "node" | grep ark-node | awk '{print $1}')
PROCESS_FOREVER=$(forever --plain list | grep ${PROCESS_NODE} | sed -nr 's/.*\[(.*)\].*/\1/p')

# --------------------------------------------------------------------------------------------------
# Network
# --------------------------------------------------------------------------------------------------

NETWORK='mainnet'

declare -A SNAPSHOT_SOURCES=(
    ['mainnet']="https://snapshots.ark.io/current"
    ['devnet']="https://dsnapshots.ark.io/current"
)

SNAPSHOT_SOURCE=${SNAPSHOT_SOURCES[$NETWORK]}

# --------------------------------------------------------------------------------------------------
# Directories
# --------------------------------------------------------------------------------------------------

DIRECTORY_ARK="$HOME/ark-node"
DIRECTORY_SNAPSHOT="$HOME/snapshots"
DIRECTORY_NOAH="$HOME/noah"

# --------------------------------------------------------------------------------------------------
# Timeouts / Sleeps
# --------------------------------------------------------------------------------------------------

WAIT_BETWEEN_REBUILD=15m # Waits for 2 Forging Rounds...
WAIT_BETWEEN_LOG_CHECK=5

# --------------------------------------------------------------------------------------------------
# Notifications
# --------------------------------------------------------------------------------------------------

NOTIFICATION_DRIVER=(LOG) # LOG, EMAIL, SLACK, SMS

NOTIFICATION_LOG=${DIRECTORY_NOAH}/noah.log

NOTIFICATION_EMAIL_TO="your@email.com"
NOTIFICATION_EMAIL_SUBJECT="Noah"

NOTIFICATION_SLACK_CHANNEL="@your_username"
NOTIFICATION_SLACK_FROM="Noah"
NOTIFICATION_SLACK_ICON="middle_finger"
NOTIFICATION_SLACK_SLACKTEE=$(which slacktee.sh)

NOTIFICATION_SMS_FROM="Noah"
NOTIFICATION_SMS_TO=""
NOTIFICATION_SMS_API_KEY=""
NOTIFICATION_SMS_API_SECRET=""

# --------------------------------------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------------------------------------

notify_via_log() {
    CURRENT_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

    printf "[$CURRENT_DATETIME] $1\n" >> $NOTIFICATION_LOG
}

notify_via_email() {
    CURRENT_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$CURRENT_DATETIME] $1" | mail -s "$NOTIFICATION_EMAIL_SUBJECT" "$NOTIFICATION_EMAIL_TO"
}

notify_via_sms() {
    CURRENT_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

    curl -X "POST" "https://rest.nexmo.com/sms/json" \
      -d "from=$NOTIFICATION_SMS_FROM" \
      -d "text=[$CURRENT_DATETIME] $1" \
      -d "to=$NOTIFICATION_SMS_TO" \
      -d "api_key=$NOTIFICATION_SMS_API_KEY" \
      -d "api_secret=$NOTIFICATION_SMS_API_SECRET"
}

notify_via_slack() {
    CURRENT_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$CURRENT_DATETIME] $1" | $NOTIFICATION_SLACK_SLACKTEE -c "$NOTIFICATION_SLACK_CHANNEL" -u "$NOTIFICATION_SLACK_FROM" -i "$NOTIFICATION_SLACK_ICON"
}

notify() {
    for driver in "${NOTIFICATION_DRIVER[@]}"
    do
        case $driver in
        "LOG")
            notify_via_log "$1"
            ;;
        "EMAIL")
            notify_via_email "$1"
            ;;
        "SMS")
            notify_via_sms "$1"
            ;;
        "SLACK")
            notify_via_slack "$1"
            ;;
        *)
            notify_via_log "$1"
            ;;
        esac
    done
}

node_stop() {
    notify "Stopping ARK Process...";

    cd ${DIRECTORY_ARK}
    forever stop ${PROCESS_FOREVER} >&- 2>&-
}

database_drop_user() {
    notify "Dropping Database User...";

    if [ -z "$PROCESS_POSTGRES" ]; then
        sudo service postgresql start
    fi

    sudo -u postgres dropuser --if-exists $USER
}

database_destroy() {
    notify "Dropping Database...";

    if [ -z "$PROCESS_POSTGRES" ]; then
        sudo service postgresql start
    fi

    dropdb --if-exists ark_${NETWORK}
}

database_create() {
    notify "Creating Database...";

    if [ -z "$PROCESS_POSTGRES" ]; then
        sudo service postgresql start
    fi

    sleep 1
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';" >&- 2>&-
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';" >&- 2>&-
    sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD 'password' CREATEDB;" >&- 2>&-
    sleep 1
    createdb ark_${NETWORK}
}

snapshot_download() {
    notify "Downloading Current Snapshot...";

    rm ${DIRECTORY_SNAPSHOT}/current
    wget -nv ${SNAPSHOT_SOURCE} -O ${DIRECTORY_SNAPSHOT}/current
}

snapshot_restore() {
    notify "Restoring Database...";

    if [ -z "$PROCESS_POSTGRES" ]; then
        sudo service postgresql start
    fi

    pg_restore -O -j 8 -d ark_${NETWORK} ${DIRECTORY_SNAPSHOT}/current 2>/dev/null
}

node_start() {
    notify "Starting ARK Process...";

    cd ${DIRECTORY_ARK}
    forever start app.js --genesis genesisBlock.${NETWORK}.json --config config.${NETWORK}.json >&- 2>&-
}

# --------------------------------------------------------------------------------------------------
# Observe
# --------------------------------------------------------------------------------------------------

while true;
do
    if tail -2 ${DIRECTORY_ARK}/logs/ark.log | grep -q "Blockchain not ready to receive block";
    then
        node_stop

        database_destroy
        database_drop_user
        database_create

        snapshot_download
        snapshot_restore

        node_start

        sleep $WAIT_BETWEEN_REBUILD

        break
    fi

    # Reduce CPU Overhead
    sleep $WAIT_BETWEEN_LOG_CHECK
done
