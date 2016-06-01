# -*- encoding: utf-8 -*-
# stub: unicorn 5.1.0 ruby lib
# stub: ext/unicorn_http/extconf.rb

Gem::Specification.new do |s|
  s.name = "unicorn"
  s.version = "5.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["unicorn hackers"]
  s.date = "2016-04-01"
  s.description = "unicorn is an HTTP server for Rack applications designed to only serve\nfast clients on low-latency, high-bandwidth connections and take\nadvantage of features in Unix/Unix-like kernels.  Slow clients should\nonly be served by placing a reverse proxy capable of fully buffering\nboth the the request and response in between unicorn and slow clients."
  s.email = "unicorn-public@bogomips.org"
  s.executables = ["unicorn", "unicorn_rails"]
  s.extensions = ["ext/unicorn_http/extconf.rb"]
  s.extra_rdoc_files = ["FAQ", "README", "TUNING", "PHILOSOPHY", "HACKING", "DESIGN", "CONTRIBUTORS", "LICENSE", "SIGNALS", "KNOWN_ISSUES", "TODO", "NEWS", "LATEST", "lib/unicorn.rb", "lib/unicorn/configurator.rb", "lib/unicorn/http_server.rb", "lib/unicorn/preread_input.rb", "lib/unicorn/stream_input.rb", "lib/unicorn/tee_input.rb", "lib/unicorn/util.rb", "lib/unicorn/oob_gc.rb", "lib/unicorn/worker.rb", "ISSUES", "Sandbox", "Links", "Application_Timeouts"]
  s.files = ["Application_Timeouts", "CONTRIBUTORS", "DESIGN", "FAQ", "HACKING", "ISSUES", "KNOWN_ISSUES", "LATEST", "LICENSE", "Links", "NEWS", "PHILOSOPHY", "README", "SIGNALS", "Sandbox", "TODO", "TUNING", "bin/unicorn", "bin/unicorn_rails", "ext/unicorn_http/extconf.rb", "lib/unicorn.rb", "lib/unicorn/configurator.rb", "lib/unicorn/http_server.rb", "lib/unicorn/oob_gc.rb", "lib/unicorn/preread_input.rb", "lib/unicorn/stream_input.rb", "lib/unicorn/tee_input.rb", "lib/unicorn/util.rb", "lib/unicorn/worker.rb"]
  s.homepage = "http://unicorn.bogomips.org/"
  s.licenses = ["GPL-2.0+", "Ruby-1.8"]
  s.required_ruby_version = Gem::Requirement.new("< 3.0")
  s.rubygems_version = "2.5.1"
  s.summary = "Rack HTTP server for fast clients and Unix"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<kgio>, ["~> 2.6"])
      s.add_runtime_dependency(%q<raindrops>, ["~> 0.7"])
      s.add_development_dependency(%q<test-unit>, ["~> 3.0"])
      s.add_development_dependency(%q<olddoc>, ["~> 1.2"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<kgio>, ["~> 2.6"])
      s.add_dependency(%q<raindrops>, ["~> 0.7"])
      s.add_dependency(%q<test-unit>, ["~> 3.0"])
      s.add_dependency(%q<olddoc>, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<kgio>, ["~> 2.6"])
    s.add_dependency(%q<raindrops>, ["~> 0.7"])
    s.add_dependency(%q<test-unit>, ["~> 3.0"])
    s.add_dependency(%q<olddoc>, ["~> 1.2"])
  end
end
