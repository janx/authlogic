# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "mongoid-authlogic"
  s.version     = "3.3.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jan Xie", "Ben Johnson"]
  s.email       = ["jan.h.xie@gmail.com", "bjohnson@binarylogic.com"]
  s.homepage    = "http://github.com/janx/authlogic"
  s.summary     = %q{A clean, simple, and unobtrusive ruby authentication solution.}
  s.description = %q{A clean, simple, and unobtrusive ruby authentication solution.}

  s.add_dependency 'mongoid', '>= 3.0'
  s.add_dependency 'activesupport', '>= 3.2'
  s.add_dependency 'activemodel', '>= 3.2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'bcrypt-ruby'
  s.add_development_dependency 'scrypt'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'i18n'
  s.add_development_dependency 'moped'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
