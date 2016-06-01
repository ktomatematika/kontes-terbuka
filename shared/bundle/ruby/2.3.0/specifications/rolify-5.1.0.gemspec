# -*- encoding: utf-8 -*-
# stub: rolify 5.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rolify"
  s.version = "5.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florent Monbillard", "Wellington Cordeiro"]
  s.date = "2016-03-19"
  s.description = "Very simple Roles library without any authorization enforcement supporting scope on resource objects (instance or class). Supports ActiveRecord and Mongoid ORMs."
  s.email = ["f.monbillard@gmail.com", "wellington@wellingtoncordeiro.com"]
  s.homepage = "https://github.com/RolifyCommunity/rolify"
  s.licenses = ["MIT"]
  s.rubyforge_project = "rolify"
  s.rubygems_version = "2.5.1"
  s.summary = "Roles library with resource scoping"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<ammeter>, ["~> 1.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.10"])
      s.add_development_dependency(%q<rake>, ["~> 10.4"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 3.4"])
    else
      s.add_dependency(%q<ammeter>, ["~> 1.1"])
      s.add_dependency(%q<bundler>, ["~> 1.10"])
      s.add_dependency(%q<rake>, ["~> 10.4"])
      s.add_dependency(%q<rspec-rails>, ["~> 3.4"])
    end
  else
    s.add_dependency(%q<ammeter>, ["~> 1.1"])
    s.add_dependency(%q<bundler>, ["~> 1.10"])
    s.add_dependency(%q<rake>, ["~> 10.4"])
    s.add_dependency(%q<rspec-rails>, ["~> 3.4"])
  end
end
