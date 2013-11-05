# docker-provider

A spike on a [Docker](http://www.docker.io/) provider for [Vagrant](http://www.vagrantup.com/)
1.3+.


## Warning

This is highly experimental and is just 8 [tomatoes](http://pomodorotechnique.com/)
worth of development / testing.


## Requirements

* Vagrant 1.3+
* Docker 0.6.5+


## Features

* Support for Vagrant's `up`, `destroy`, `halt`, `reload` and `ssh` commands
* Port forwarding
* Synced / shared folders support
* Set container hostnames from Vagrantfiles
* Provision Docker containers with any built-in Vagrant provider

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

Assuming you have Vagrant 1.3+ and Docker 0.6.5+ installed just sing that same
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

Another thing to keep in mind is that Docker is all about _application containers_
and not _machine containers_. I failed to boot a Docker container in what people
have been calling "[machine mode](https://github.com/dotcloud/docker/issues/2170#issuecomment-26118964)"
and some hacking will be required in order to run multiple processes on the
container as described below. For more information about the issues related to
it, please search Docker's issue tracker for `/sbin/init` and / or "machine mode".


## Box format

Every provider in Vagrant must introduce a custom box format. This provider introduces
`docker` boxes and you can view some examples in the [`boxes`](boxes) directory.
That directory also contains instructions on how to build them.

The box format is basically just the required `metadata.json` file along with a
`Vagrantfile` that does default settings for the provider-specific configuration
for this provider.


## Running multiple processes on the container

Unless you are able to run the container in "machine mode", you'll need to create
a custom command / script that starts the processes you need prior to firing up
the SSH server. An example can be found at the [`boxes/nginx`](boxes/nginx)
folder of this repo.

On a side note, if you really need your Docker containers to behave like machines
with Vagrant and you can't get it to work that way like me, you might want to use
[vagrant-lxc](https://github.com/fgrehm/vagrant-lxc) as an alternative.


## Got feedback?

Please keep in mind that this is a spike and I'm not sure if / how the project
will evolve. I'm planning to write about why I built this at some point but
in case you have any feedback feel free to open up an [issue here on GitHub](https://github.com/fgrehm/docker-provider/issues),
shoot a tweet to [@fgrehm](https://twitter.com/fgrehm) or send a mail to the
address available on my GitHub profile.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgrehm/docker-provider/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
