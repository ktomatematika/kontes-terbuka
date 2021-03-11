# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
require 'haml'

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths <<
  Rails.root.join('app/assets/html')

class HamlTemplate < Tilt::HamlTemplate
  def prepare
    @options = @options.merge format: :html5
    super
  end
end

Rails.application.config.before_initialize do
  require 'sprockets'
  Sprockets.register_mime_type 'text/haml', extensions: ['.haml']
  Sprockets.register_transformer 'text/haml', 'text/html', HamlTemplate
end

Rails.application.config.assets.precompile << /\.(?:woff2|eot|woff|ttf)$/

NonStupidDigestAssets.whitelist = [/\.(?:woff2|eot|woff|ttf|html)$/]
