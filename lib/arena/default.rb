module Arena
  module Default
    BASE_DOMAIN = "api.are.na" unless defined? BASE_DOMAIN
    API_VERSION = "v2" unless defined? API_VERSION

    class << self
      # @return [Hash]
      def options
        Hash[Arena::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def api_version
        API_VERSION
      end

      def base_domain
        BASE_DOMAIN
      end
    end
  end
end