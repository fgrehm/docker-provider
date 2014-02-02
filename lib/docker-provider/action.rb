require_relative 'action/check_running'
require_relative 'action/created'
require_relative 'action/create'
require_relative 'action/destroy'
require_relative 'action/forward_ports'
require_relative 'action/stop'
require_relative 'action/message'
require_relative 'action/prepare_nfs_valid_ids'
require_relative 'action/is_running'
require_relative 'action/start'

module VagrantPlugins
  module DockerProvider
    module Action
      # Shortcuts
      Builtin = Vagrant::Action::Builtin
      Builder = Vagrant::Action::Builder

      # This action brings the "machine" up from nothing, including creating the
      # container, configuring metadata, and booting.
      def self.action_up
        Builder.new.tap do |b|
          b.use Builtin::ConfigValidate
          b.use Builtin::Call, Created do |env, b2|
            if !env[:result]
              b2.use Builtin::HandleBoxUrl
              # TODO: Find out where this fits into the process
              # b2.use Builtin::EnvSet, :port_collision_repair => true
              # b2.use Builtin::HandleForwardedPortCollisions
              b2.use Builtin::Provision
              b2.use PrepareNFSValidIds
              b2.use Builtin::SyncedFolderCleanup
              b2.use Builtin::SyncedFolders
              b2.use ForwardPorts
              # This will actually create and start, but that's fine
              b2.use Create
              b2.use action_boot
            end
          end
          b.use action_start
        end
      end

      # This action just runs the provisioners on the machine.
      def self.action_provision
        Builder.new.tap do |b|
          b.use Builtin::ConfigValidate
          b.use Builtin::Call, Created do |env1, b2|
            if !env1[:result]
              b2.use Message, :not_created
              next
            end

            b2.use Builtin::Call, IsRunning do |env2, b3|
              if !env2[:result]
                b3.use Message, :not_running
                next
              end

              b3.use Builtin::Provision
            end
          end
        end
      end

      # This is the action that is primarily responsible for halting
      # the virtual machine, gracefully or by force.
      def self.action_halt
        Builder.new.tap do |b|
          b.use Builtin::Call, Created do |env, b2|
            if env[:result]
              # TODO: Make use of this once we figure out how to run dockers in machine mode
              # b2.use Builtin::Call, Builtin::GracefulHalt, :stopped, :running do |env2, b3|
              b2.use Stop
            else
              b2.use Message, :not_created
            end
          end
        end
      end

      # This action is responsible for reloading the machine, which
      # brings it down, sucks in new configuration, and brings the
      # machine back up with the new configuration.
      def self.action_reload
        Builder.new.tap do |b|
          b.use Builtin::Call, Created do |env1, b2|
            if !env1[:result]
              b2.use Message, :not_created
              next
            end

            b2.use Builtin::ConfigValidate
            b2.use action_halt
            b2.use action_start
          end
        end
      end

      # This is the action that is primarily responsible for completely
      # freeing the resources of the underlying virtual machine.
      def self.action_destroy
        Builder.new.tap do |b|
          b.use Builtin::Call, Created do |env1, b2|
            if !env1[:result]
              b2.use Message, :not_created
              next
            end

            b2.use Builtin::Call, Builtin::DestroyConfirm do |env2, b3|
              if env2[:result]
                b3.use Builtin::ConfigValidate
                b3.use Builtin::EnvSet, :force_halt => true
                b3.use action_halt
                b3.use Destroy
                b3.use Builtin::ProvisionerCleanup
              else
                b3.use Message, :will_not_destroy
              end
            end
          end
        end
      end

      # This is the action that will exec into an SSH shell.
      def self.action_ssh
        Builder.new.tap do |b|
          b.use CheckRunning
          b.use Builtin::SSHExec
        end
      end

      # This is the action that will run a single SSH command.
      def self.action_ssh_run
        Builder.new.tap do |b|
          b.use CheckRunning
          b.use Builtin::SSHRun
        end
      end

      def self.action_start
        Builder.new.tap do |b|
          b.use Builtin::ConfigValidate
          b.use Builtin::Call, IsRunning do |env, b2|
            # If the container is running, then our work here is done, exit
            next if env[:result]

            b2.use Builtin::Provision
            b2.use Message, :starting
            b2.use action_boot
          end
        end
      end

      def self.action_boot
        Builder.new.tap do |b|
          # TODO: b.use Builtin::SetHostname
          b.use Start
          b.use Builtin::WaitForCommunicator
        end
      end
    end
  end
end
