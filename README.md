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
along the way:

* http://asciinema.org/a/6162
* http://asciinema.org/a/6177


## Getting started

If you are on a Mac / Windows machine, please fire up a x64 VM with Docker +
Vagrant installed or use [this Vagrantfile](https://gist.github.com/fgrehm/fc48fb51ec7df64439e4)
and follow the instructions from there.

The plugin is not very user friendly at the moment, so please download the base
Docker image manually with `docker pull fgrehm/vagrant-ubuntu:precise` in order
to have some feedback about the download process.

Assuming you have Vagrant 1.4+ and Docker 0.7.0+ installed just sing that same
old song:

```
vagrant plugin install docker-provider
vagrant box add precise http://bit.ly/vagrant-docker-precise
vagrant init precise
vagrant up --provider=docker
```


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
    docker.image = "your/image:tag"
    docker.cmd   = ["/path/to/your", "command"]
  end
end
```


## Limitations

There's probably a whole lot of limitations right now but during these early days
of the plugin I can tell you for sure that some things are probably not going to
work as you might expect. For instance forwarded ports, synced folders and containers'
hostnames will not be reconfigured on `vagrant reload`s if they have changed and
the plugin **_will not give you any kind of warning or message_**. For instance,
if you change your Puppet manifests / Chef cookbooks paths (which are shared /
synced folders under the hood), **_you'll need to start from scratch_**. Oh,
and forwarded ports automatic collision handling is **_not supported as well_**.

The plugin also requires Docker's executable to be available on current user's `PATH`
and that the current user has been added to the `docker` group since we are not
using `sudo` when interacting with Docker's CLI. For more information on setting
this up please check [this page](http://docs.docker.io/en/latest/use/basics/#why-sudo).


## Box format

Every provider in Vagrant must introduce a custom box format. This provider introduces
`docker` boxes and you can view some examples in the [`boxes`](boxes) directory.
That directory also contains instructions on how to build them.

The box format is basically just the required `metadata.json` file along with a
`Vagrantfile` that does default settings for the provider-specific configuration
for this provider.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgrehm/docker-provider/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
