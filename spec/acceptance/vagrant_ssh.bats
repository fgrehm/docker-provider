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

@test "vagrant ssh on a stopped container errors out" {
  cd /vagrant/spec/acceptance

  run bundle exec vagrant ssh
  [ "$status" -eq 1 ]
}

@test "vagrant ssh on a runing container" {
  cd /vagrant/spec/acceptance
  bundle exec vagrant up

  run bundle exec vagrant ssh -c 'echo "hello from ssh"'

  [ "$status" -eq 0 ]
  echo $output | grep -q 'hello from ssh'
}
