# -*- encoding: utf-8 -*-
# stub: katex-rails 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "katex-rails"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brandon Aaron"]
  s.date = "2014-09-27"
  s.description = "KaTeX with Rails integration"
  s.email = ["hello.brandon@aaron.sh"]
  s.homepage = ""
  s.rubygems_version = "2.5.1"
  s.summary = "KaTeX with Rails integration"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<less-rails>, [">= 2.5.0"])
      s.add_development_dependency(%q<bundler>, ["= 1.5.2"])
      s.add_development_dependency(%q<rake>, ["= 10.1.1"])
      s.add_development_dependency(%q<rails>, [">= 0"])
    else
      s.add_dependency(%q<less-rails>, [">= 2.5.0"])
      s.add_dependency(%q<bundler>, ["= 1.5.2"])
      s.add_dependency(%q<rake>, ["= 10.1.1"])
      s.add_dependency(%q<rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<less-rails>, [">= 2.5.0"])
    s.add_dependency(%q<bundler>, ["= 1.5.2"])
    s.add_dependency(%q<rake>, ["= 10.1.1"])
    s.add_dependency(%q<rails>, [">= 0"])
  end
end
