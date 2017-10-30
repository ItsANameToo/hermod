# Noah

> Automated Rebuilds for [ark-node](https://github.com/ArkEcosystem/ark-node).

## Installation

```bash
git clone https://github.com/faustbrian/Noah
```

## Configuration

If you wish to use a different notification driver then the default one you will need to open `~/noah/noah.sh` and change the following variables to your liking.

```bash
# --------------------------------------------------------------------------------------------------
# Notifications
# --------------------------------------------------------------------------------------------------

NOTIFICATION_DRIVER="LOG"

NOTIFICATION_LOG=${DIRECTORY_NOAH}/rebuild.log

NOTIFICATION_EMAIL_TO="your@email.com"
NOTIFICATION_EMAIL_SUBJECT="Noah"

NOTIFICATION_SLACK_CHANNEL="@your_username"
NOTIFICATION_SLACK_FROM="Noah"
NOTIFICATION_SLACK_ICON="middle_finger"

NOTIFICATION_SMS_FROM="Noah"
NOTIFICATION_SMS_TO=""
NOTIFICATION_SMS_API_KEY=""
NOTIFICATION_SMS_API_SECRET=""
```

### E-Mail

If you wish to use **EMAIL** as your notification driver you will need to install and configure [Postfix](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-on-ubuntu-16-04).

### SMS

If you wish to use **SMS** as your notification driver you will need to sign up for [Nexmo](https://www.nexmo.com).

### Slack

If you wish to use **Slack** as your notification driver you will need to install and configure [slacktee](https://github.com/course-hero/slacktee).

## Usage

Start **noah** by executing `forever start --pidFile ~/noah/rebuild.pid -c bash ~/noah/rebuild.sh` in your terminal.

This will guarantee that the script will run forever which means even if it crashes it will be automatically restarted.

Run `ps ax | grep '/home/ark/noah/rebuild.sh' && ps ax | grep '~/noah/rebuild.sh'` and make sure there are only 2 processes related to the `rebuild.sh`.

## Security

If you discover a security vulnerability within this package, please send an e-mail to Brian Faust at hello@brianfaust.me. All security vulnerabilities will be promptly addressed.

## Credits

- [Brian Faust](https://github.com/faustbrian)
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © [Brian Faust](https://brianfaust.me)
