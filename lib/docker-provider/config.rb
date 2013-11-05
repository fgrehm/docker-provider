module VagrantPlugins
  module DockerProvider
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :image, :cmd, :ports

      def initialize
        @image = UNSET_VALUE
        @cmd   = UNSET_VALUE
        @ports = UNSET_VALUE
      end

      def finalize!
        @ports = [] if @ports == UNSET_VALUE
        @cmd   = [] if @cmd == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        errors << I18n.t("docker_provider.errors.config.image_not_set") if @image == UNSET_VALUE
        # TODO: Detect if base image has a CMD / ENTRYPOINT set before erroring out
        errors << I18n.t("docker_provider.errors.config.cmd_not_set")   if @cmd == UNSET_VALUE

        { "docker-provider" => errors }
      end
    end
  end
end
