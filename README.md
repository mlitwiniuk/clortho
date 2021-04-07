# Clortho

> _The Keymaster_ from the [Ghostbusters movie](https://en.wikipedia.org/wiki/List_of_Ghostbusters_characters#The_Terror_Dogs:_Zuul_The_Gatekeeper_and_Vinz_Clortho_The_Keymaster)


Simple app allowing you to manage SSH keys on servers you have access to. It is **not meant** to be hosted anywhere (at least not for now). Connection is done using [SSHKit](https://github.com/capistrano/sshkit).


## Installation

It's a standard ruby app. If you don't know what to do, please wait for Dockerfile to come (to be added next).


## Usage

Just start it. To fetch keys from other source than GitHub change `config/settings.yml` file (or overwrite in `config/settings/{env}.yml`). First users needs to be created by hand from Rails console.

## Security

For now - absolutely none. App only (by default) binds to localhost, so until you change something, it will be accessible only from you local machine. Nonetheless it is not meant to be run permanenly - if you need it, start it, use it, then shut it down.

## ToDo

- [ ] Dockerfile
- [ ] db encryption?
- [ ] server groups
- [ ] (better) error handling
- [ ] possibility to execute commands in backgroun


