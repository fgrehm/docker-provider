# docker-provider

[![Build Status](https://travis-ci.org/fgrehm/docker-provider.png?branch=master)](https://travis-ci.org/fgrehm/docker-provider) [![Gem Version](https://badge.fury.io/rb/docker-provider.png)](http://badge.fury.io/rb/docker-provider) [![Gittip](http://img.shields.io/gittip/fgrehm.svg)](https://www.gittip.com/fgrehm/)

A [Docker](http://www.docker.io/) provider for [Vagrant](http://www.vagrantup.com/)
1.4+.


## Warning

This is experimental, expect things to break.


## Requirements

* Vagrant 1.4+
* Docker 0.7.0+


## Features

* Support for Vagrant's `up`, `destroy`, `halt`, `reload` and `ssh` commands
* Port forwarding
* Synced / shared folders support
* Set container hostnames from Vagrantfiles
* Provision Docker containers with any built-in Vagrant provisioner

You can see the plugin in action by watching the following "teasers" I published
while I was working on its early days:

* http://asciinema.org/a/6162
* http://asciinema.org/a/6177


## Getting started

If you are on a Mac / Windows machine, please fire up a x64 Linux VM with Docker +
Vagrant 1.4+ installed or use [this Vagrantfile](https://gist.github.com/fgrehm/fc48fb51ec7df64439e4)
and follow the instructions from within the VM.

### Initial setup

_If you are trying things out from a Vagrant VM using the `Vagrantfile` gisted
above, you can skip to the next section_

The plugin requires Docker's executable to be available on current user's `PATH`
and that the current user has been added to the `docker` group since we are not
using `sudo` when interacting with Docker's CLI. For more information on setting
this up please check [this page](http://docs.docker.io/en/latest/installation/ubuntulinux/#giving-non-root-access).

### Add base box

On its current state, the plugin does not provide any kind of feedback about the
process of downloading Docker images, so before you add a `docker-provider`
[base box](http://docs.vagrantup.com/v2/boxes.html) it is recommended that you
`docker pull` the associated base box images prior to spinning up `docker-provider`
containers (otherwise you'll be staring at a blinking cursor without any progress
information).

Assuming you have Vagrant 1.4+ and Docker 0.7.0+ installed just sing that same
old song:

```sh
vagrant plugin install docker-provider
docker pull fgrehm/vagrant-ubuntu:precise
vagrant box add precise64 http://bit.ly/vagrant-docker-precise
vagrant init precise64
vagrant up --provider=docker
```

Under the hood, that base box will [configure](#configuration) `docker-provider`
to use the [`fgrehm/vagrant-ubuntu:precise`](https://index.docker.io/u/fgrehm/vagrant-ubuntu/)
image that approximates a standard Vagrant box (`vagrant` user, default SSH key,
etc.) and you should be good to go.


## Configuration


## Using custom images

If you want to use a custom Docker image without creating a Vagrant base box,
you can use a "dummy" box:

```
vagrant box add dummy http://bit.ly/vagrant-docker-dummy
```

And configure things from your `Vagrantfile` like in [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean#configure)
or [vagrant-aws](https://github.com/mitchellh/vagrant-aws#quick-start):

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"
  config.vm.provider :docker do |docker|
    docker.image      = "your/image:tag"
    docker.cmd        = ["/path/to/your", "command"]
    docker.privileged = true # Defaults to false
  end
end
```


## Available boxes


## Box format

Every provider in Vagrant must introduce a custom box format. This provider introduces
`docker` boxes and you can view some examples in the [`boxes`](boxes) directory.
That directory also contains instructions on how to build them.

The box format is basically just the required `metadata.json` file along with a
`Vagrantfile` that does default settings for the provider-specific configuration
for this provider.


## Limitations

There's probably a lot of limitations right now but during these early days
of the plugin I can tell you for sure that some things are probably not going to
work as you might expect. For instance forwarded ports, synced folders and containers'
hostnames will not be reconfigured on `vagrant reload`s if they have changed and
the plugin **_will not give you any kind of warning or message_**. For instance,
if you change your Puppet manifests / Chef cookbooks paths (which are shared /
synced folders under the hood), **_you'll need to start from scratch_** (unless you
make them NFS / rsync shared folders). This is due to a limitation in Docker itself as
we can't change those parameters after the container has been created. Forwarded
ports automatic collision handling is **_not supported as well_**.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
