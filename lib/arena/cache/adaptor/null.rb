require "arena/error/cache_error"

module Arena
  module Cache
    module Adaptor
      class Null
        def self.method_missing(method, *args, &block)
          raise Arena::Error::CacheError
        end
      end
    end
  end
end
