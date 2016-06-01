# -*- encoding: utf-8 -*-
# stub: recaptcha 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "recaptcha"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jason L Perry"]
  s.date = "2016-04-08"
  s.description = "Helpers for the reCAPTCHA API"
  s.email = ["jasper@ambethia.com"]
  s.homepage = "http://github.com/ambethia/recaptcha"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.5.1"
  s.summary = "Helpers for the reCAPTCHA API"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<maxitest>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
      s.add_development_dependency(%q<bump>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<maxitest>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
      s.add_dependency(%q<bump>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<maxitest>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
    s.add_dependency(%q<bump>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
