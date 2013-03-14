require "arena/cache/adaptor/rails"
require "arena/cache/adaptor/padrino"
require "arena/cache/adaptor/null"

module Arena
  module Cache
    class Cached
      class << self
        def adapt_to
          if defined?(Rails)
            "Rails"
          elsif defined?(Padrino)
            "Padrino"
          else
            "Null"
          end
        end

        # Delegate to the appropriate cache engine
        # 
        def method_missing(method, *args, &block)
          "Arena::Cache::Adaptor::#{adapt_to}".constantize.send(method, *args, &block)
        end
      end
    end
  end
end
