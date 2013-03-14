module Arena
  module Default
    BASE_DOMAIN = "api.are.na" unless defined? BASE_DOMAIN
    API_VERSION = "v2" unless defined? API_VERSION
    USE_CACHING = false unless defined? USE_CACHING
    EXPIRES_IN  = 600 unless defined? EXPIRES_IN # 10 minutes

    class << self
      def options
        Hash[Arena::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def api_version
        API_VERSION
      end

      def base_domain
        BASE_DOMAIN
      end

      def application_id
        ENV["APPLICATION_ID"]
      end

      def application_secret
        ENV["APPLICATION_SECRET"]
      end

      def access_token
        ENV["APPLICATION_SECRET"]
      end

      def auth_token
        ENV["AUTH_TOKEN"]
      end

      def use_caching
        USE_CACHING
      end

      def expires_in
        EXPIRES_IN
      end

      def padrino_app_name
        if defined?(Padrino)
          Padrino.mounted_apps.first.name
        else
          nil
        end
      end
    end
  end
end
