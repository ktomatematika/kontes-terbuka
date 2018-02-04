source 'https://rubygems.org'

### BASICS

# Ruby version
ruby '2.5.0'
# Rails version
gem 'rails', '~> 4'
# Use postgres as database
gem 'pg'
# For Travis CI
gem 'rake', group: :test

### END BASICS

### VIEWS, ASSETS, FRONTEND STUFF

# HAML makes your life easier
gem 'haml', '>= 5.0.0'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use jQuery
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '< 5'
gem 'jquery-turbolinks'
# Use Bootstrap, the CSS framework (getbootstrap.com)
gem 'bootstrap-sass'
# Javascript interpreter
gem 'therubyracer', platforms: :ruby
# Adds attachments
gem 'paperclip'
# Adds nested forms
gem 'nested_form'
# Markdown parser
gem 'redcarpet'
# Zip submissions
gem 'rubyzip', '>= 1.2.1'
# Autoprefixer for SCSS
gem 'autoprefixer-rails'
# Inline SVG
gem 'inline_svg'

group :development do
  # Favicon set
  gem 'rails_real_favicon', '>= 0.0.7'
end

### END ASSETS

### UTILITIES

# Schema Validations: to maintin referential integrity in database and models
gem 'schema_validations', github: 'donjar/schema_validations'
# Add time validations
gem 'validates_timeliness'
# Allows more complex SQL queries
gem 'squeel'
# Adds delayed job queueing for jobs that are executed in the future
gem 'delayed_job_active_record'
# Do not generate digests for error pages
gem 'non-stupid-digest-assets'
# Add pagination
gem 'will_paginate'
# Generate PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
# Facebook Graph API
gem 'koala'
# Environment variables
gem 'dotenv-rails', require: 'dotenv/rails-now'

group :test do
  # Test coverage
  gem 'coveralls', require: false
  # Acceptance testing
  gem 'capybara'
  # Driver for Capybara to allow JS stuff
  gem 'selenium-webdriver', '>= 3.0.5'
  # Allow transcations with Capybara and Selenius
  gem 'transactional_capybara'
end

group :development do
  # Annotates model with schema
  gem 'annotate'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Shoot those n+1 queries!
  gem 'bullet'
  # Trace routes
  gem 'traceroute'
  # ?
  gem 'table_flipper'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  # Factory bot: factories for testing
  gem 'factory_bot_rails'
end

group :production do
  # Adds daemons for DelayedJob
  gem 'daemons'
  # Email with Mailgun
  gem 'rest-client'
end

### END UTILITIES

### QUALITY

group :development, :test do
  # Ruby linter
  gem 'rubocop'
  # HAML linter
  gem 'haml_lint', '>= 0.24.0'
  # SCSS linter
  gem 'scss_lint', require: false
end

### END QUALITY

### MAINTENANCE

# Model logging
gem 'paper_trail'
# Add browser info in logs
gem 'browser_details'

group :development, :production do
  # Database profiler
  gem 'rack-mini-profiler', require: false
  # Profiler
  gem 'newrelic_rpm'
  # Auto-email exceptions
  gem 'exception_notification'
end

group :production do
  # Sitemap generator
  gem 'sitemap_generator'
end

### END MAINTENANCE

### SECURITY

# Adds roles
gem 'rolify'
# Adds privileges
gem 'cancancan'
# Adds various security stuff. You need protection!
gem 'rack-protection'
# Adds hashes for passwords.
gem 'bcrypt'
# A recaptcha helper gem.
gem 'recaptcha', require: 'recaptcha/rails'

group :development do
  # Security checkup
  gem 'brakeman'
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
