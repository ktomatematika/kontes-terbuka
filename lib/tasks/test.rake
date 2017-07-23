# frozen_string_literal: true

namespace :test do
  Rails::TestTask.new(others: 'test:prepare') do |t|
    t.pattern = 'test/{libs,tasks}/**/*_test.rb'
  end
end
