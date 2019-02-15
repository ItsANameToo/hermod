# hermod

> Monitoring tool for Ark Core

This tool is based on the monitoring capabilities of [Noah](https://github.com/faustbrian/noah), but adjusted to work with v2 of Ark.

The reason for not going with a core plugin but a bash script instead, is because the script can still notify you if core goes down for whatever reason, while the plugin would go down with it. Nonetheless, it might be possible that I'll create a core plugin out of some of the `hermod` features too, sometime in the future.

## Installation

```
git clone https://github.com/ItsANameToo/hermod.git
cd ~/hermod
bash hermod.sh install
bash hermod.sh config # See Configuration for more details
bash hermod.sh start
```

That's it! Hermod is now monitoring your logs

## Configuration

After running `bash hermod.sh install`, there will be a `.hermod` file available where you can change the configuration to your preference.
At a minimum, you should go over and fill in some of the following configuration:

```bash
# Notification settings, by default these should be fine, but you can decide to increase / reduce it to your liking
monitor_lines=10 # if you have debug logs enabled, 20 lines is better
monitor_interval=3
monitor_sleep_after_notif=10
monitor_lines_halted=5

# Delegate info to properly filter the log messages. Both should be filled in with your delegate details.
delegate_username=''
delegate_public_key=''

# Core settings, set the path to core (usually $HOME/core or $HOME/ark-core), and the network (devnet or mainnet).
core_path=$HOME/ark-core
core_network=mainnet
core_log_path="$HOME/.local/state/ark-core/$core_network"

# Snapshot settings, enabling the snapshot module will automatically take snapshots and append blocks to existing snapshots.
snapshots_enable=true

# How you would like to be notified. Don't forget to change this line to one (or more) ways in which you would like to be updated.
notification_drivers=(log slack discord)
```

### Snapshots

When rounds are saved on core, hermod will take snapshots, or append to the most recent one. It is enabled by default and it will keep the 5 most recent snapshots. Older snapshots are deleted. Make sure that you have enough storage space. 

### Notifications

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

### Testing

You can check whether you have confired your notifications correctly by running `bash hermod.sh test notify MESSAGE`. This will send `MESSAGE` to each of the notification drivers you've configured in the config.

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
    monitor                   Temporarily monitor the log.
    install                   Setup hermod interactively.
    update                    Update the hermod installation.
    config                    Configure the hermod installation.
    log                       Show the hermod log.
    test [method] [params]    Test the specified method.
    alias                     Create a bash alias for hermod.
    snapshot                  Take a new snapshot, or append to the most recent one.
    rollback                  Roll back to the most recent snapshot.
```

## Credits

- [ItsANameToo](https://github.com/itsanametoo)
- [vmunich (Arkland)](https://github.com/vmunich)
- [Brian Faust](https://github.com/faustbrian) - Noah implementation
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © ItsANameToo / vmunich / Brian Faust