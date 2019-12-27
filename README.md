# hermod

> Monitoring & Snapshot tool for Ark Core

This tool is based on the monitoring and snapshot capabilities of [Noah](https://github.com/faustbrian/noah), but adjusted to work with v2 of Ark.

The reason for not going with a core plugin but a bash script instead, is because the script can still notify you if core goes down for whatever reason, while the plugin would go down with it. Nonetheless, it is possible that a core plugin with a subset of `hermod` features might be created sometime in the future.

## Installation

```bash
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

# Snapshot settings, enabling the snapshot module will automatically take snapshots and append blocks to existing snapshots.
# Note: only enable automatic snapshots on relay nodes!
snapshots_enable=true

# Core settings, set the path to core (usually $HOME/core or $HOME/ark-core), and the network (devnet or mainnet).
core_path=$HOME/ark-core
core_network=mainnet
core_log_path="$HOME/.local/state/ark-core/$core_network"

# How you would like to be notified. Don't forget to change this line to one (or more) ways in which you would like to be updated.
notification_drivers=(log slack discord)
```

### Snapshots

When rounds are saved on core, hermod will take snapshots, or append to the most recent one. It will keep the 5 most recent snapshots and older snapshots are deleted. Make sure that you have enough storage space on your node!

With the introduction of core 2.6, snapshots can only be taken when core is shut down, which `hermod` will handle for you. Due to the nature of having to shut down core, it is STRONGLY advised to only enable automatic snapshots on relay nodes and it will be disabled by default. Of course it is always possible to manually create a snapshot with `hermod snapshot`, but please remember that this will temporarily shutdown core too!

#### Sharing Snapshots

If you need share a snapshot with someone, `hermod` facilitates it. By running `hermod share`, the command will archive the most recent snapshot, and host it on an URL that you can share with others. To be able to use this command, you must have at least one snapshot (you can run `hermod snapshot` to take one), and port `8080` must be open.

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
    share                     Hosts the most recent snapshot on a temporary URL.
```

## Upgrading

When upgrading from v2.x.x to v2.1.0, you should double check the following:

- in earlier `hermod` versions, automatic snapshots are enabled by default. Please **disable** this on forging nodes, as core 2.6 will require a full shutdown to be able to take a snapshot.
- you will have to set a `snapshots_rounds` variable in your `.hermod` to indicate after how many rounds a snapshot should be taken

---

When upgrading from v1.x.x to v2.x.x, you should make the following changes:

- In your `.hermod` configuration file, you should add `core_processes=<number>`, where `<number>` is either `2` (if you run `ark-relay` and `ark-forger` as separate processes, or `1` if you run the combined `ark-core` process). You can see an example of this in the [`.hermod.example`](https://github.com/ItsANameToo/hermod/blob/master/.hermod.example#L30) file.

Make sure to restart `hermod` to have the changes take effect!

## Credits

- [ItsANameToo](https://github.com/itsanametoo)
- [vmunich (Arkland)](https://github.com/vmunich)
- [Brian Faust](https://github.com/faustbrian) - Noah implementation
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © ItsANameToo / vmunich / Brian Faust