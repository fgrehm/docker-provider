require 'vagrant/errors'

module VagrantPlugins
  module DockerProvider
    module Errors
      class NfsWithoutPrivilegedError < Vagrant::Errors::VagrantError
        error_key(:docker_provider_nfs_without_privileged)
      end
    end
  end
end
