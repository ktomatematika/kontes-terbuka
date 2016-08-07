source 'https://rubygems.org'

### BASICS

# Ruby version
ruby '2.3.1'
# Rails version
gem 'rails', '4.2.6'
# Use postgres as database.
gem 'pg'

### END BASICS

### VIEWS, ASSETS, FRONTEND STUFF

# HAML makes your life easier
gem 'haml'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use jQuery
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Use Bootstrap, the CSS framework (getbootstrap.com)
gem 'bootstrap-sass'
# Javascript interpreter
gem 'therubyracer', platforms: :ruby
# Adds attachments, in the form of long submissions
gem 'paperclip'
# Adds nested forms
gem 'nested_form'
# Markdown parser
gem 'redcarpet'
# Zip submissions
gem 'rubyzip'

group :development do
  # Favicon set
  gem 'rails_real_favicon'
end

### END ASSETS

### UTILITIES

# Migration Validators: to maintin referential integrity in database and models
gem 'mv-postgresql'
# Email with Mailgun
gem 'rest-client'
# Allows for more complex SQL queries
gem 'squeel'
# Adds delayed job queueing for jobs that are executed in the future
gem 'delayed_job_active_record'
# Adds daemons for DelayedJob
gem 'daemons'
# Annotates model with schema
gem 'annotate'
# Add comments in models
gem 'migration_comments'
# Do not generate digssts for error pages
gem 'non-stupid-digest-assets'
# Add pagination
gem 'will_paginate', github: 'jonatack/will_paginate'
# Try: line-bot
gem 'line-bot-api'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # ?
  gem 'table_flipper'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

### END UTILITIES

### MAINTENANCE

# Model logging
gem 'paper_trail'
# Profiler
gem 'newrelic_rpm'
# Add browser info in logs
gem 'browser_details'
# Sitemap generator
gem 'sitemap_generator'
# Auto-email exceptions
gem 'exception_notification'
# Database profiler
gem 'rack-mini-profiler', require: false

### END MAINTENANCE

### SECURITY

# Authorization gem. Adds roles.
gem 'rolify'
# Another authorization gem; adds privileges.
gem 'cancancan'
# A recaptcha helper gem.
gem 'recaptcha', require: 'recaptcha/rails'
# Adds various security stuff. You need protection!
gem 'rack-protection'
# Adds hashes for passwords.
gem 'bcrypt'

group :development do
  # Security checkup
  gem 'brakeman', require: false
end

### END SECURITY

### PRODUCTION STUFF

group :production do
  # Use unicorn as the web server.
  gem 'unicorn'

  # This gem kills unicorn workers after certain time to prevent memory
  # leakage.
  gem 'unicorn-worker-killer'
end

group :development do
  # Use capistrano and its extensions.
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
  gem 'capistrano3-delayed-job'
end

### END PRODUCTION STUFF
