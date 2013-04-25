require "arena/version"
require_relative "./arena/client"
require_relative "./arena/default"
require_relative "./arena/configurable"

module Arena
  class << self
    include Arena::Configurable

    # Delegate to a Arena::Client
    #
    # @return [Arena::Client]
    # 
    def client
      if @client
        @client
      else
        @client = Arena::Client.new(options)
      end
    end

  private

    def method_missing(method, *args, &block)
      self.client.send(method, *args, &block)
    end
  end # self
end # Arena

Arena.setup