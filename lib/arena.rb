# frozen_string_literal: true

require 'arena/version'

require 'arena/client'
require 'arena/default'
require 'arena/configurable'
require 'arena/v3'

module Arena
  class << self
    include Arena::Configurable

    # Delegate to a Arena::Client
    #
    # @return [Arena::Client]
    #
    def client
      @client || @client = Arena::Client.new(options)
    end

    # Returns a client for the v3 API, using the global configuration
    # unless overridden by options.
    #
    # @return [Arena::V3::Client]
    #
    def v3(options = {})
      Arena::V3::Client.new(options)
    end

    private

    def method_missing(method, ...)
      client.send(method, ...)
    end
  end
end

Arena.setup
