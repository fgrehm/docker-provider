# Ubuntu Precise base box

This folder contains an example of a Dockerfile that builds an image ready for
usage with Vagrant. Please check out the [source](boxes/precise/Dockerfile)
for more information on building your own.

To turn this into a box:

```
docker build -t myuser/vagrant-ubuntu:precise .
docker push myuser/vagrant-ubuntu:precise
sed 's/IMAGE/myuser\/vagrant-ubuntu:precise/' Vagrantfile.sample > Vagrantfile
tar cvzf precise.box ./metadata.json ./Vagrantfile
```

This box works by using Vagrant's built-in `Vagrantfile` merging to setup defaults
for Docker. These defaults can easily be overwritten by higher-level Vagrantfiles
(such as project root Vagrantfiles).
