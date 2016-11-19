# vim: set ft=ruby:

SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.lines.count < 5
  end

  # The dev is too lazy to test these legacy stuff
  add_filter '/app/controllers/line_controller.rb'
  add_filter '/app/controllers/travis_controller.rb'
  add_filter '/app/tasks/dump_kto_hasil.rb'
  add_filter 'app/tasks/line_nag.rb'
end
