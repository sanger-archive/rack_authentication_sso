# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack_authentication_sso}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Thornthwaite"]
  s.date = %q{2009-06-23}
  s.email = %q{paul.thornthwaite@sanger.ac.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/rack_authentication_sso.rb",
     "test/rack_authentication_sso_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/sanger/rack_authentication_sso}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Rack middleware to abstract Sanger SSO}
  s.test_files = [
    "test/rack_authentication_sso_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
