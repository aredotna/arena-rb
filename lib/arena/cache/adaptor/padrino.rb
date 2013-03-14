require "arena/cache/adaptor/generic"

module Arena
  module Cache
    module Adaptor
      class Padrino < Arena::Cache::Adaptor::Generic
        def self.method_missing(method, *args, &block)
          # todo
        end
      end
    end
  end
end
