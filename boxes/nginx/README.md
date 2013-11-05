# Nginx base box example

This folder contains an example of a box that is able to run multiple processes.
With the provided `Dockerfile` you'll be able to build a base box that runs both
nginx and a SSH server that is required by Vagrant to do its "magic".


```
docker build -t myuser/vagrant-nginx .
docker push myuser/vagrant-nginx
sed 's/IMAGE/myuser\/vagrant-nginx/' Vagrantfile.sample > Vagrantfile
tar cvzf nginx.box ./metadata.json ./Vagrantfile
```

In order to reach the nginx server running on the container you'll need to
forward the ports with a `Vagrantfile` like the one below:

```ruby
Vagrant.configure("2") do |config|
  # Replace with the name of the box you used when adding
  config.vm.box = "nginx"
  # This makes nginx accessible from the host from http://localhost:8080
  config.vm.network "forwarded_port", guest: 80, host: 8080
end
```
