# frozen_string_literal: true

require 'minitest/autorun'
require File.expand_path('../lib/arena.rb', __dir__)

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

# Wraps each spec in a VCR cassette named after its describe blocks and description,
# e.g. test/cassettes/Arena/channel/returns_a_channel.yml.
module VcrCassette
  def before_setup
    super
    VCR.insert_cassette(cassette_name)
  end

  def after_teardown
    VCR.eject_cassette
    super
  end

  private

  def cassette_name
    [*self.class.name.split('::'), name.sub(/\Atest_\d+_/, '')].map { |part| part.gsub(/[^\w-]+/, '_') }.join('/')
  end
end

Minitest::Spec.include VcrCassette
