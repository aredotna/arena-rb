# frozen_string_literal: true

module Arena
  module Default
    BASE_DOMAIN = 'api.are.na' unless defined? BASE_DOMAIN
    API_VERSION = 'v2' unless defined? API_VERSION

    class << self
      def options
        Arena::Configurable.keys.to_h { |key| [key, send(key)] }
      end

      def api_version
        API_VERSION
      end

      def base_domain
        BASE_DOMAIN
      end

      def application_id
        ENV.fetch('ARENA_CLIENT_ID', nil)
      end

      def application_secret
        ENV.fetch('ARENA_CLIENT_SECRET', nil)
      end

      def access_token
        ENV.fetch('ARENA_ACCESS_TOKEN', nil)
      end

      def auth_token
        ENV.fetch('ARENA_AUTH_TOKEN', nil)
      end

      def user_agent
        "arena-rb/#{Arena::VERSION} (+https://github.com/aredotna/arena-rb)"
      end
    end
  end
end
