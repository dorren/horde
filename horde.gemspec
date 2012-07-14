# -*- encoding: utf-8 -*-
require File.expand_path('../lib/horde/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dorren Chen"]
  gem.email         = ["dorrenchen@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "horde"
  gem.require_paths = ["lib"]
  gem.version       = Horde::VERSION

  gem.add_dependency "mysql2"
  gem.add_dependency 'activerecord'
  gem.add_dependency 'activesupport'
  gem.add_dependency "sinatra-activerecord"
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency "database_cleaner"
end
