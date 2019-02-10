# hermod

> Monitoring tool for Ark Core

This tool is based on the monitoring capabilities of [Noah](https://github.com/faustbrian/noah), but adjusted to work with v2 of Ark.

## Installation

```
git clone https://github.com/ItsANameToo/hermod.git
cd ~/hermod
bash hermod.sh install
bash hermod.sh start
```

That's it! Hermod is now monitoring your logs

## Configuration

After running `bash hermod.sh install`, there will be a `.hermod` file available where you can change the configuration to your preference.
At a minimum, you should go over and fill in some of the following configuration:

```bash
# Notification settings, by default these should be fine, but you can decide to increase / reduce it to your liking
monitor_lines=10
monitor_interval=1
monitor_sleep_after_notif=10

# Delegate info to properly filter the log messages. Both should be filled in with your delegate details.
delegate_username=''
delegate_public_key=''

# How you would like to be notified. Don't forget to change this line to one (or more) ways in which you would like to be updated.
notification_drivers=(log)  
```

There are a couple of services that you can use to get notified by the script.
These are currently the following:

* Discord, with the use of [webhooks](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
* Slack, with the use of [webhooks](https://api.slack.com/incoming-webhooks)
* [Postfix](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-on-ubuntu-16-04) (email)
* [Nexmo](https://nexmo.com/)
* [Pushover](https://pushover.net/)
* [Pushbullet](https://pushbullet.com/)
* [Mailgun](https://mailgun.com/)
* [Twillio](https://www.twilio.com/) - `twilio_message` will send you SMS, and `twilio_call` will call you when there's a problem with your node

## Commands

```
Usage: hermod.sh [options]
options:
    help                      Show this help.
    version                   Show the installed version.
    start                     Start the hermod process.
    stop                      Stop the hermod process.
    restart                   Restart the hermod process.
    reload                    Reload the hermod process.
    delete                    Delete the hermod process.
    rebuild                   Start the rebuild process.
    monitor                   Temporarily monitor the log.
    install                   Setup hermod interactively.
    update                    Update the hermod installation.
    config                    Configure the hermod installation.
    log                       Show the hermod log.
    test [method] [params]    Test the specified method.
    alias                     Create a bash alias for hermod.
```

## Credits

- [ItsANameToo](https://github.com/itsanametoo)
- [Brian Faust](https://github.com/faustbrian) - Noah implementation
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © ItsANameToo / Brian Faust