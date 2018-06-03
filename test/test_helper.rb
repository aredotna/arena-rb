require 'minitest/autorun'
require File.expand_path('../../lib/arena.rb', __FILE__)

require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end

require 'minitest-vcr'
MinitestVcr::Spec.configure!
