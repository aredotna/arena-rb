require File.expand_path('lib/arena/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['dzuc']
  gem.email         = ['everyone@aredotna.com']
  gem.description   = "Wrapper for Arena's API"
  gem.summary       = "Wrapper for Arena's API"
  gem.homepage      = 'https://www.are.na/'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name          = 'arena'
  gem.require_paths = ['lib']
  gem.version       = Arena::VERSION

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-vcr'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'webmock'

  gem.add_dependency 'httparty'
  gem.add_dependency 'json'
  gem.metadata['rubygems_mfa_required'] = 'true'
end
