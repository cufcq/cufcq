# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sinatra"
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Blake Mizerany", "Ryan Tomayko", "Simon Rozet"]
  s.date = "2010-03-23"
  s.description = "Classy web-development dressed in a DSL"
  s.email = "sinatrarb@googlegroups.com"
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "LICENSE"]
  s.homepage = "http://sinatra.rubyforge.org"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "sinatra"
  s.rubygems_version = "1.8.23"
  s.summary = "Classy web-development dressed in a DSL"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0"])
      s.add_development_dependency(%q<shotgun>, ["< 1.0", ">= 0.6"])
      s.add_development_dependency(%q<rack-test>, [">= 0.3.0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<erubis>, [">= 0"])
      s.add_development_dependency(%q<less>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0"])
      s.add_dependency(%q<shotgun>, ["< 1.0", ">= 0.6"])
      s.add_dependency(%q<rack-test>, [">= 0.3.0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<less>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0"])
    s.add_dependency(%q<shotgun>, ["< 1.0", ">= 0.6"])
    s.add_dependency(%q<rack-test>, [">= 0.3.0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<less>, [">= 0"])
  end
end
