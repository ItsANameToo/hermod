# noah ~ Automated Rebuilds for [ArkEcosystem/ark-node](https://github.com/ArkEcosystem/ark-node)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/faustbrian/noah.git
```

### 2. Add noah to your visudo configuration

> This step is required to guarantee that noah can execute all `sudo` commands required to rebuild your node without your intervention.

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

If you wish to use **EMAIL** as your notification driver you will need to install and configure [Postfix](https://digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-on-ubuntu-16-04).

### SMS

If you wish to use **SMS** as your notification driver you will need to sign up for [Nexmo](https://nexmo.com).

### Pushover

If you wish to use **Pushover** as your notification driver you will need to sign up for [Pushover](https://pushover.net).

### Slack

If you wish to use **Slack** as your notification driver you will need to install and configure [slacktee](https://github.com/course-hero/slacktee).

## Usage

### 1. Observe

```bash
forever start --pidFile ~/noah/noah.pid -c bash ~/noah/noah.sh
```

Run `ps ax | grep '/home/ark/noah/noah.sh' && ps ax | grep '~/noah/noah.sh'` and make sure there are only 2 processes related to the `noah.sh`.

### 2. Force

```bash
bash ~/noah/noah.sh -f
```

## Security

If you discover a security vulnerability within this package, please send an e-mail to Brian Faust at hello@brianfaust.me. All security vulnerabilities will be promptly addressed.

## Credits

- [Brian Faust](https://github.com/faustbrian)
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © [Brian Faust](https://brianfaust.me)
