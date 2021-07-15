# frozen_string_literal: true

# vim: set ft=ruby:

require 'coveralls'
SimpleCov.formatters = [Coveralls::SimpleCov::Formatter,
                        SimpleCov::Formatter::HTMLFormatter]
SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Tasks', 'app/tasks'
  add_group 'Libraries', 'lib'

  add_filter 'app/helpers'
  add_filter 'config'
  add_filter 'db'
  add_filter 'test'
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end
