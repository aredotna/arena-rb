require "arena/cache/adaptor/generic"

module Arena
  module Cache
    module Adaptor
      class Padrino < Arena::Cache::Adaptor::Generic
        def self.method_missing(method, *args, &block)
          padrino =
            if !Arena.padrino_app_name.nil?
              Arena.padrino_app_name.constantize
            else
              Padrino.mounted_apps.first.name.constantize
            end

          key = args.present? ? "arena_#{method}_#{args.first}" : "arena_#{method}"
          cache = padrino.cache.get(key)

          if cache.nil?
            padrino.cache.set(key, Arena.send(method, id), expires_in: Arena.expires_in)
            cache = padrino.cache.get(key)
          end

          cache
        end
      end
    end
  end
end
