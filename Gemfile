source 'https://rubygems.org'

# Specify your gem's dependencies in docker-provider.gemspec
gemspec

group :development, :test do
  gem 'vagrant',      github: 'mitchellh/vagrant', tag: 'v1.4.3'
  gem 'vagrant-spec', github: 'mitchellh/vagrant-spec', ref: 'fbd067bbe5e2a789bb2b29c38d1224cdd9386836'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-inotify'

  gem 'vagrant-notify',   github: 'fgrehm/vagrant-notify'
  gem 'vagrant-cachier',  github: 'fgrehm/vagrant-cachier'
  gem 'vagrant-pristine', github: 'fgrehm/vagrant-pristine'
  gem 'vagrant-lxc',      github: 'fgrehm/vagrant-lxc'
  gem 'ventriloquist',    github: 'fgrehm/ventriloquist'
end
