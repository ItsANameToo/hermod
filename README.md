# noah ~ Automated Rebuilds for [ArkEcosystem/ark-node](https://github.com/ArkEcosystem/ark-node)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/faustbrian/noah.git
```

### 2. Add noah to your visudo configuration

```bash
sudo visudo
ark ALL=(ALL) NOPASSWD:ALL
```

### 3. Start noah with forever

```bash
forever start --pidFile ~/noah/noah.pid -c bash ~/noah/noah.sh
```

## Configuration

If you wish to use a different configuration then the default one you will need to open `~/noah/noah.conf` and change it to suit your needs.

### E-Mail

If you wish to use **EMAIL** as your notification driver you will need to install and configure [Postfix](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-on-ubuntu-16-04).

### SMS

If you wish to use **SMS** as your notification driver you will need to sign up for [Nexmo](https://www.nexmo.com).

### Slack

If you wish to use **Slack** as your notification driver you will need to install and configure [slacktee](https://github.com/course-hero/slacktee).

## Usage

Start **noah** by executing `forever start --pidFile ~/noah/noah.pid -c bash ~/noah/noah.sh` in your terminal.

This will guarantee that the script will run forever which means even if it crashes it will be automatically restarted.

Run `ps ax | grep '/home/ark/noah/noah.sh' && ps ax | grep '~/noah/noah.sh'` and make sure there are only 2 processes related to the `noah.sh`.

## Security

If you discover a security vulnerability within this package, please send an e-mail to Brian Faust at hello@brianfaust.me. All security vulnerabilities will be promptly addressed.

## Credits

- [Brian Faust](https://github.com/faustbrian)
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © [Brian Faust](https://brianfaust.me)
