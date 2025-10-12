require 'arena/error/cache_error'

module Arena
  module Cache
    module Adaptor
      class Null
        def self.method_missing(_method, *_args)
          raise Arena::Error::CacheError
        end
      end
    end
  end
end
