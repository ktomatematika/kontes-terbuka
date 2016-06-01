# -*- encoding: utf-8 -*-
require File.expand_path("../lib/katex/rails/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "katex-rails"
  s.version       = Katex::Rails::VERSION
  s.authors       = ["Brandon Aaron"]
  s.email         = ["hello.brandon@aaron.sh"]
  s.description   = %q{KaTeX with Rails integration}
  s.summary       = %q{KaTeX with Rails integration}
  s.homepage      = ""

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path  = "lib"

  s.add_runtime_dependency "less-rails", ">= 2.5.0"
  s.add_development_dependency "bundler", "= 1.5.2"
  s.add_development_dependency "rake", "= 10.1.1"
  s.add_development_dependency "rails"
end
