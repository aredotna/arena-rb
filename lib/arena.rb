require 'arena/version'

require 'arena/client'
require 'arena/default'
require 'arena/configurable'

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

    private

    def method_missing(method, ...)
      client.send(method, ...)
    end
  end # self
end # Arena

Arena.setup
