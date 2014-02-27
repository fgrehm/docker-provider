## [0.1.0](https://github.com/fgrehm/docker-provider/compare/v0.0.2...0.1.0) (Feb 27, 2014)

BACKWARDS INCOMPATIBILITY:

  - Support for Vagrant < 1.4 and Docker < 0.7.0 are gone, please use a previous
    plugin version if you can't upgrade.

FEATURES:

  - Trusted build for official base boxes Docker images [GH-5]
  - New base boxes / images for running Ubuntu 12.04 in "machine mode"
  - New [dind](https://github.com/jpetazzo/dind) Ubuntu 12.04 base box
  - Support for NFS Synced Folders
  - Support for running privileged containers

IMPROVEMENTS:

  - Decrease timeout taken before killing a container on `vagrant halt`s
  - Remove volumes along with containers with `docker rm -v` on `vagrant destroy`s
  - Sanity checks using [vagrant-spec](https://github.com/mitchellh/vagrant-spec)

BUG FIXES:

  - Fix `vagrant up` failure with newer Vagrant and Docker versions.

## [0.0.2](https://github.com/fgrehm/docker-provider/compare/v0.0.1...v0.0.2) (November 5, 2013)

  - Fix provisioning with Vagrant's built in provisioners

## 0.0.1 (November 5, 2013)

  - Initial public release.
