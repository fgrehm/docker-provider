FROM fgrehm/vagrant-ubuntu:precise

RUN apt-get update && apt-get install lxc -yq --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'

RUN curl -sLS https://get.docker.io | sh

RUN usermod -aG docker vagrant

RUN curl -sLS https://raw.github.com/dotcloud/docker/master/hack/dind -o /dind && \
    chmod +x /dind

CMD ["/dind", "/sbin/init"]
