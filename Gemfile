source 'https://rubygems.org'

# My ruby version
ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

# Postgres
gem 'pg'

group :development do
	# Access an IRB console on exception pages or by using <%= console %> in views
	gem 'web-console'

	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'

	# Cap stuff
	gem 'capistrano'
	gem 'capistrano-bundler'
	gem 'capistrano-rails'
	gem 'capistrano-rvm', github: "capistrano/rvm"
	gem 'capistrano-unicorn-nginx'
	gem 'capistrano-safe-deploy-to'
	gem 'capistrano-postgresql'
end

group :development, :test do
	# Call 'byebug' anywhere in the code to stop execution and get a debugger console
	gem 'byebug'

	gem 'dotenv-rails'
end

group :production do
	gem 'rails_12factor'
	gem 'unicorn'
	gem 'unicorn-worker-killer'
end

group :assets do
	gem 'therubyracer', :platforms => :ruby
end

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails'

gem 'recaptcha', require: "recaptcha/rails"

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

gem 'bcrypt', :require => 'bcrypt' 
gem 'bootstrap-sass'
gem 'devise'
gem 'carrierwave'
gem 'mini_magick'
gem "rolify"
gem 'cancancan'
gem 'hirb'
gem 'table_print'
gem 'katex-rails'
gem 'paperclip'
gem "nested_form"
gem 'rails_admin'
gem 'paper_trail'
