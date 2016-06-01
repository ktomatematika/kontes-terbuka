#!/usr/bin/env rake
require 'bundler/gem_tasks'

namespace :katex do

  KATEX_FONTS  = FileList["katex/static/fonts/*.*"]
  ASSETS_FONTS = KATEX_FONTS.pathmap("vendor/assets/fonts/katex/%f")
  ASSETS_FONTS.zip(KATEX_FONTS).each do |target, source|
    file target => [source] { cp source, target, verbose: true }
  end

  KATEX_JS  = FileList["katex/build/katex.js"]
  ASSETS_JS = KATEX_JS.pathmap("vendor/assets/javascripts/katex/%f")
  ASSETS_JS.zip(KATEX_JS).each do |target, source|
    file target => [source] { cp source, target, verbose: true }
  end

  KATEX_LESS  = FileList["katex/static/*.less"]
  ASSETS_LESS = KATEX_LESS.pathmap("vendor/assets/stylesheets/katex/%f")
  ASSETS_LESS.zip(KATEX_LESS).each do |target, source|
    file target => [source] { cp source, target, verbose: true }
  end

  desc "Update KaTeX"
  task :update => [:pull, :build, :clean, :fonts, :less, :js]

  desc "Everything but updating KaTeX"
  task :rebuild => [:build, :clean, :fonts, :less, :js]

  desc "Update KaTeX submodule"
  task :pull do
    abort "...." if !system "cd katex && git pull"
  end

  desc "Build KaTeX"
  task :build do
    abort "...." if !system "cd katex && make build"
  end

  desc "Clean gem assets files"
  task :clean do
    FileUtils.rm_rf 'vendor/assets'
    FileUtils.mkpath 'vendor/assets/fonts/katex'
    FileUtils.mkpath 'vendor/assets/javascripts/katex'
    FileUtils.mkpath 'vendor/assets/stylesheets/katex'
  end

  desc "Copy fonts"
  task :fonts => ASSETS_FONTS

  desc "Copy Less"
  task :less => ASSETS_LESS do
    # Inject font-path helper
    fonts_path = 'vendor/assets/stylesheets/katex/fonts.less'
    fonts = File.read fonts_path
    fonts.gsub!('@font-folder: "fonts";', '@font-folder: "katex";')
    fonts.gsub!(/url\(/, "font-url(")
    File.write(fonts_path, fonts)
  end

  desc "Copy JS"
  task :js => ASSETS_JS
end
