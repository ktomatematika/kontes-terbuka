ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Setup rails to run on 0.0.0.0 in the virtual machine
require 'rails/commands/server'

module Rails
	class Server
		if Rails.env == 'development'
			new_defaults = Module.new do
				def default_options
					super.merge(Host: '0.0.0.0')
				end
			end
		end

		prepend new_defaults
	end
end
