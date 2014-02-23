# Ubuntu Precise "Docker in Docker" enabled base box

To turn this into a box:

```
docker build -t myuser/vagrant-ubuntu:precise-dind .
docker push myuser/vagrant-ubuntu:precise-dind
sed 's/IMAGE/myuser\/vagrant-ubuntu:precise-dind/' Vagrantfile.sample > Vagrantfile
tar cvzf precise-dind.box ./metadata.json ./Vagrantfile
```
