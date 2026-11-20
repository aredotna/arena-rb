# frozen_string_literal: true

require File.expand_path('lib/arena/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'arena'
  gem.version       = Arena::VERSION
  gem.authors       = ['dzuc']
  gem.email         = ['everyone@aredotna.com']
  gem.summary       = 'Ruby client for the Are.na API.'
  gem.description   = 'A Ruby client for the Are.na v3 and legacy v2 APIs.'
  gem.homepage      = 'https://github.com/aredotna/arena-rb'
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb', 'CHANGELOG.md', 'LICENSE', 'README.md']
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 3.0'

  gem.add_dependency 'httparty'
  gem.add_dependency 'json'

  gem.metadata = {
    'bug_tracker_uri' => 'https://github.com/aredotna/arena-rb/issues',
    'changelog_uri' => 'https://github.com/aredotna/arena-rb/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.are.na/developers',
    'rubygems_mfa_required' => 'true'
  }
end
