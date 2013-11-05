source 'https://rubygems.org'

# Specify your gem's dependencies in docker-provider.gemspec
gemspec

group :development, :test do
  gem 'vagrant', github: 'mitchellh/vagrant'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-inotify'

  gem 'vagrant-notify',        github: 'fgrehm/vagrant-notify'
  gem 'vagrant-cachier',       github: 'fgrehm/vagrant-cachier'
  gem 'vagrant-pristine',      github: 'fgrehm/vagrant-pristine'
  gem 'vagrant-lxc',           github: 'fgrehm/vagrant-lxc'
  gem 'vagrant-global-status', github: 'fgrehm/vagrant-global-status'
  gem 'ventriloquist',         github: 'fgrehm/ventriloquist'
end
