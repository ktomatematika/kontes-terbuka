require 'less-rails'

module Katex
  module Rails
    class Engine < ::Rails::Engine
      initializer 'katex-rails.assets.fonts' do |app|
        app.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
      end
      initializer 'katex-rails.assets.less' do |app|
        config.less.paths << root.join('vendor', 'assets', 'stylesheets')
      end
    end
  end
end
