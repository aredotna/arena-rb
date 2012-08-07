module Arena
  module Configurable

    CONFIG_KEYS = [
      :base_domain,
      :api_version,
    ] unless defined? CONFIG_KEYS

    attr_accessor *CONFIG_KEYS

    class << self
      def keys
        @keys ||= CONFIG_KEYS
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