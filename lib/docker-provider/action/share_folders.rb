module VagrantPlugins
	module DockerProvider
		module Action
			class ShareFolders
				def initialize(app, env)
					@app = app
				end

				def call(env)
					@env = env
					prepare_folders

					# FIXME: Check whether the container has already been created with
					#        different synced folders and let the user know about it
					folders = []
					shared_folders.each do |id, data|
						folders << {
							:name      => id,
							:hostpath  => File.expand_path(data[:hostpath], @env[:root_path]),
							:guestpath => data[:guestpath]
						}
					end
					@env[:synced_folders] = folders

					@app.call(env)
				end

				# This method returns an actual list of synced folders to create and their
				# proper path.
				def shared_folders
					{}.tap do |result|
						@env[:machine].config.vm.synced_folders.each do |id, data|
							# Ignore disabled shared folders
							next if data[:disabled]
							# This to prevent overwriting the actual shared folders data
							result[id] = data.dup
						end
					end
				end

				# Prepares the shared folders by verifying they exist and creating them
				# if they don't.
				def prepare_folders
					shared_folders.each do |id, options|
						hostpath = Pathname.new(options[:hostpath]).expand_path(@env[:root_path])

						if !hostpath.directory? && options[:create]
							# Host path doesn't exist, so let's create it.
							@logger.debug("Host path doesn't exist, creating: #{hostpath}")

							begin
								hostpath.mkpath
							rescue Errno::EACCES
								raise Vagrant::Errors::SharedFolderCreateFailed,
									:path => hostpath.to_s
							end
						end
					end
				end
			end
		end
	end
end
