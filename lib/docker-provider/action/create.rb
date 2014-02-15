module VagrantPlugins
  module DockerProvider
    module Action
      class Create
        def initialize(app, env)
          @app = app
          @@mutex ||= Mutex.new
        end

        def call(env)
          @env             = env
          @machine         = env[:machine]
          @provider_config = @machine.provider_config
          @machine_config  = @machine.config
          @driver          = @machine.provider.driver

          cid = ''
          @@mutex.synchronize do
            cid = @driver.create(create_params)
          end

          @machine.id = cid
          @app.call(env)
        end

        def create_params
          container_name = "#{@env[:root_path].basename.to_s}_#{@machine.name}"
          container_name.gsub!(/[^-a-z0-9_]/i, "")
          container_name << "_#{Time.now.to_i}"

          {
            image:      @provider_config.image,
            cmd:        @provider_config.cmd,
            ports:      forwarded_ports,
            name:       container_name,
            hostname:   @machine_config.vm.hostname,
            volumes:    @provider_config.volumes,
            privileged: @provider_config.privileged
          }
        end

        def forwarded_ports
          @env[:forwarded_ports].map do |fp|
            # TODO: Support for the protocol argument
            "#{fp[:host]}:#{fp[:guest]}"
          end.compact
        end
      end
    end
  end
end
