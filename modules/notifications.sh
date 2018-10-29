#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

notify_via_log()
{
    printf "$1\n" >> $notification_log
}

notify_via_email()
{
    echo "$1" | mail -s "$notification_email_subject" "$notification_email_to"
}

notify_via_nexmo()
{
    curl -X "POST" "https://rest.nexmo.com/sms/json" \
      -d "from=$notification_nexmo_from" \
      -d "text=$1" \
      -d "to=$notification_nexmo_to" \
      -d "api_key=$notification_nexmo_api_key" \
      -d "api_secret=$notification_nexmo_api_secret"
}

notify_via_pushover()
{
    curl -s -F "token=$notification_pushover_token" \
        -F "user=$notification_pushover_user" \
        -F "title=$notification_pushover_title" \
        -F "message=$1" https://api.pushover.net/1/messages.json
}

notify_via_pushbullet()
{
    curl --header "Access-Token: $notification_pushbullet_access_token" \
         --header 'Content-Type: application/json' \
         --data-binary "{\"body\":\"$1\",\"title\":\"$notification_pushbullet_title\",\"type\":\"note\"}" \
         --request POST \
         https://api.pushbullet.com/v2/pushes
}

notify_via_mailgun()
{
    curl -s --user "api:$notifications_mailgun_api_key" \
        "https://api.mailgun.net/v3/$notifications_mailgun_domain/messages" \
        -F from="$notifications_mailgun_from <mailgun@$notifications_mailgun_domain>" \
        -F to="$notifications_mailgun_to" \
        -F subject="$notifications_mailgun_subject" \
        -F text="$1"
}

notify_via_slack()
{
    curl -X POST -H 'Content-type: application/json' \
         --data "{\"text\":\"$1\", \"username\":\"$notification_slack_from\", \"channel\":\"$notification_slack_channel\", \"icon_emoji\":\"$notification_slack_emoji\"}" \
         "$notification_slack_webhook"
}

notify_via_discord()
{
    curl -X POST "$notification_discord_webhook" \
        -F content="$1"
}

notify_via_twilio_call()
{
    curl -X "POST" "https://api.twilio.com/2010-04-01/Accounts/$notifications_twilio_account_sid/Calls.json" \
        --data-urlencode "Url=http://demo.twilio.com/docs/voice.xml" \
        --data-urlencode "From=$notifications_twilio_from" \
        --data-urlencode "To=$notifications_twilio_to" \
        -u "$notifications_twilio_account_sid:$notifications_twilio_auth_token"
}

notify_via_twilio_message()
{
    curl -X "POST" "https://api.twilio.com/2010-04-01/Accounts/$notifications_twilio_account_sid/Messages.json" \
        --data-urlencode "From=$notifications_twilio_from" \
        --data-urlencode "Body=$1" \
        --data-urlencode "To=$notifications_twilio_to" \
        -u "$notifications_twilio_account_sid:$notifications_twilio_auth_token"
}

notify()
{
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$datetime] $1"

    for driver in ${notification_drivers[@]}; do
        case $driver in
            log)
                notify_via_log "$message"
            ;;
            email)
                notify_via_email "$message"
            ;;
            mailgun)
                notify_via_mailgun "$message"
            ;;
            pushover)
                notify_via_pushover "$message"
            ;;
            pushbullet)
                notify_via_pushbullet "$message"
            ;;
            nexmo)
                notify_via_nexmo "$message"
            ;;
            slack)
                notify_via_slack "$message"
            ;;
            discord)
                notify_via_discord "$message"
            ;;
            twilio_message)
                notify_via_twilio_message "$message"
            ;;
            twilio_call)
                notify_via_twilio_call "$message"
            ;;
            *)
                :
            ;;
        esac
    done
}
