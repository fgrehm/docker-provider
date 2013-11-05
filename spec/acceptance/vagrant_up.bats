#!/usr/bin/env bats

setup() {
  if ! [ $USER = 'vagrant' ]; then
    echo 'The specs should be run from a Vagrant VM'
    exit 1
  fi

  # Destroy all of acceptance specs related containers
  containers=$(docker ps -a | grep acceptance | wc -l)
  if [ "$containers" -gt 0 ]; then
    test_containers=$(docker ps -a | grep acceptance | cut -d' ' -f1)
    docker stop -t=1 $test_containers
    docker rm $test_containers
  fi
  rm -rf /vagrant/spec/acceptance/{.vagrant,tmp}
}

@test "vagrant up from scratch runs a docker container" {
  cd /vagrant/spec/acceptance

  run bundle exec vagrant up
  [ "$status" -eq 0 ]

  # How many test containers have we got?
  count=$(docker ps | grep acceptance | wc -l)
  [ "$count"  -eq 1 ]
}

@test "vagrant up from scratch provisions docker container" {
  cd /vagrant/spec/acceptance
  run bundle exec vagrant up

  echo $output | grep -q 'hello from docker'
}
