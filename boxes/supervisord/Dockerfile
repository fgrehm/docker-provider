# Based on http://docs.docker.io/en/latest/examples/running_riak_service/

# Start with a docker-provider ready image
FROM fgrehm/vagrant-ubuntu:precise
RUN apt-get update && apt-get install nginx supervisor -y && apt-get clean

# Tks to http://stackoverflow.com/a/18861635/2738223
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Hack for initctl
# See: https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
