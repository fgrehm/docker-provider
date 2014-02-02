# Nginx supervisord base box example

This folder contains an example of a box that is able to run multiple processes
using [supervisord](http://supervisord.org/introduction.html). With the provided
`Dockerfile` you'll be able to build a base box that runs both nginx and a SSH
server that is required by Vagrant to do its "magic".


```
docker build -t myuser/vagrant-nginx-supervisord .
docker push myuser/vagrant-nginx-supervisord
sed 's/IMAGE/myuser\/vagrant-nginx-supervisord/' Vagrantfile.sample > Vagrantfile
tar cvzf nginx-supervisord.box ./metadata.json ./Vagrantfile
```

In order to reach the nginx server running on the container you'll need to
forward the ports with a `Vagrantfile` like the one below:

```ruby
Vagrant.configure("2") do |config|
  # Replace with the name of the box you used when adding
  config.vm.box = "nginx-supervisord"
  # This makes nginx accessible from the host from http://localhost:8080
  config.vm.network "forwarded_port", guest: 80, host: 8080
end
```
