# Start with a docker-provider ready image
FROM fgrehm/vagrant-ubuntu:precise
RUN apt-get update && apt-get install nginx -y
ADD ./start /bin/start-container
