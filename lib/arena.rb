require "arena/version"
require_relative "./arena/client"
require_relative "./arena/configurable"

module Arena
  class << self
    def client
      Arena::Client
    end
  end
end
