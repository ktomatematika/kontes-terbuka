SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.lines.count < 5
  end
end
