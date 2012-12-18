module Arena
  module Configurable
    attr_accessor :base_domain,
                  :api_version

    attr_writer :application_id,
                :application_secret,
                :access_token,
                :auth_token

    class << self
      def keys
        @keys ||= [
          :base_domain,
          :api_version,
          :application_id,
          :application_secret,
          :access_token,
          :auth_token
        ]
      end
    end

    # Allows configuration options
    # to be set in a block
    def configure
      yield self
      self
    end

    def reset!
      Arena::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Arena::Default.options[key])
      end
      self
    end

    alias setup reset!

  private

    # @return [Hash]
    def options
      Hash[Arena::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  end
end
