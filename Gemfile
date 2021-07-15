# frozen_string_literal: true

source 'https://rubygems.org'

### BASICS

# Ruby version
ruby '2.5.0'
# Rails version
gem 'rails', '~> 4'
# Use postgres as database
gem 'pg', '< 1'
# For Travis CI
gem 'rake', group: :test

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
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Use Bootstrap, the CSS framework (getbootstrap.com)
gem 'bootstrap-sass'
# Javascript interpreter
# gem 'therubyracer', platforms: :ruby
# Adds attachments
gem 'paperclip'
# Adds nested forms
gem 'nested_form'
# Markdown parser
gem 'redcarpet'
# Zip submissions
gem 'rubyzip'
# Autoprefixer for SCSS
gem 'autoprefixer-rails'
# Inline SVG
gem 'inline_svg'
# Sprockets
gem 'sprockets', '< 4'

group :development do
  # Favicon set
  gem 'rails_real_favicon'
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
  # Acceptance testing
  gem 'capybara'
  # Driver for Capybara to allow JS stuff
  gem 'selenium-webdriver'
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
  # ?
  gem 'table_flipper'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  # Factory bot: factories for testing
  gem 'factory_bot_rails'
  # Trace routes
  gem 'traceroute'
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
  gem 'rubocop', '~> 1.11.0'
  # Rails cops extracted to rubocop-rails gem
  gem 'rubocop-rails'
  # HAML linter
  gem 'haml_lint'
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

group :development, :test do
  # Security checkup
  gem 'brakeman'
end

### END SECURITY

### PRODUCTION STUFF

group :development do
  # Use capistrano and its extensions.
  gem 'capistrano'
  gem 'capistrano3-delayed-job'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
end

### END PRODUCTION STUFF
