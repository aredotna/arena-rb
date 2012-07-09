# -*- encoding: utf-8 -*-
require File.expand_path('../lib/arena/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["dzuc"]
  gem.email         = ["everyone@are.na"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://are.na/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "arena"
  gem.require_paths = ["lib"]
  gem.version       = Arena::VERSION

  gem.add_development_dependency 'rake'

  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'httparty'

end
