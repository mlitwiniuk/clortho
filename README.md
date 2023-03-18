# Clortho

> _The Keymaster_ from the [Ghostbusters movie](https://en.wikipedia.org/wiki/List_of_Ghostbusters_characters#The_Terror_Dogs:_Zuul_The_Gatekeeper_and_Vinz_Clortho_The_Keymaster)


Simple app allowing you to manage SSH keys on servers you have access to. It is **not meant** to be hosted anywhere (at least not for now). Connection is done using [SSHKit](https://github.com/capistrano/sshkit).

Users public keys are fetched from configurable source, by default from Github (eg. https://github.com/mlitwiniuk.keys)


## Installation

It's a standard ruby app. To ease initial setup, development environment is aided via [dip](https://github.com/bibendi/dip). To start install dip, have docker running and execute:

```
$ dip provision
# within the output you'll get password for first created user, it's login is going to be test@clortho.dev

$ dip rails s
```

**Warning:** contenerized env (as well as regular app) will have access to your `~/.ssh` folder - it's required to read your public key used to connect to servers


## Usage

Just start it. To fetch keys from other source than GitHub change `config/settings.yml` file (or overwrite in `config/settings/{env}.yml`).

## Security

For now - absolutely none. App only (by default) binds to localhost, so until you change something, it will be accessible only from you local machine. Nonetheless it is not meant to be run permanenly - if you need it, start it, use it, then shut it down.

## ToDo

- [x] Dockerfile
- [ ] db encryption?
- [ ] server groups
- [ ] (better) error handling
- [ ] possibility to execute commands in the background


