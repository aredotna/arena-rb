require "arena/cache/adaptor/generic"

module Arena
  module Cache
    module Adaptor
      class Padrino < Arena::Cache::Adaptor::Generic
        def self.method_missing(method, *args, &block)
          client = Arena::Client.new
          app    = Arena.padrino_app_name.constantize || Padrino.mounted_apps.first.name.constantize
          key    = !args.nil? ? "arena_#{method}_#{args.first}" : "arena_#{method}"
          cache  = padrino.cache.get(key)

          if cache.nil?
            object = !args.nil? ? client.send(method, args.first) : client.send(method)

            padrino.cache.set(key, client.send(method, id), expires_in: Arena.expires_in)
            
            cache = padrino.cache.get(key)
          end

          cache
        end
      end
    end
  end
end
