require "arena/cache/adaptor/generic"

module Arena
  module Cache
    module Adaptor
      class Rails < Arena::Cache::Adaptor::Generic
        def self.method_missing(method, *args, &block)
          # Brittle/ugly but works for the time being
          # 
          key = args.present? ? "arena_#{method}_#{args.first}" : "arena_#{method}"
          cache = Rails.cache.read(key)

          if cache.nil?
            object = args.present? ? Arena.send(method, args.first) : Arena.send(method)
            
            Rails.cache.write(key, object, expires_in: Arena.expires_in)
            
            cache = Rails.cache.read(key)
          end

          cache
        end
      end
    end
  end
end
