# TODO: Switch to Vagrant.require_version before 1.0.0
#       see: https://github.com/mitchellh/vagrant/blob/bc55081e9ffaa6820113e449a9f76b293a29b27d/lib/vagrant.rb#L202-L228
unless Gem::Requirement.new('>= 1.4.0').satisfied_by?(Gem::Version.new(Vagrant::VERSION))
  raise 'vagrant-cachier requires Vagrant >= 1.4.0 in order to work!'
end

I18n.load_path << File.expand_path(File.dirname(__FILE__) + '/../../locales/en.yml')
I18n.reload!

module VagrantPlugins
  module DockerProvider
    class Plugin < Vagrant.plugin("2")
      name "docker-provider"

      provider(:docker, parallel: true) do
        require_relative 'provider'
        Provider
      end

      config(:docker, :provider) do
        require_relative 'config'
        Config
      end
    end
  end
end
