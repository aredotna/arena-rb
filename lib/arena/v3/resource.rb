# frozen_string_literal: true

module Arena
  module V3
    # A JSON object returned by the v3 API.
    #
    # Attributes are readable as methods or with [], and nested objects and
    # arrays of objects are wrapped as resources too.
    #
    #   channel = Arena.v3.channel('arena-influences')
    #   channel.title             # => "Arena Influences"
    #   channel.owner.slug        # => "are-na-team"
    #   channel[:counts][:blocks] # => 126
    class Resource
      attr_reader :attrs

      def initialize(attrs = {})
        @attrs = attrs || {}
      end

      def [](key)
        wrap(@attrs[key.to_s])
      end

      def key?(key)
        @attrs.key?(key.to_s)
      end

      def to_h
        @attrs
      end

      alias to_hash to_h

      def ==(other)
        other.is_a?(self.class) && attrs == other.attrs
      end

      def inspect
        "#<#{self.class.name} #{@attrs.inspect}>"
      end

      private

      def method_missing(name, *args)
        key = name.to_s
        return super unless args.empty? && @attrs.key?(key)

        self[key]
      end

      def respond_to_missing?(name, include_private = false)
        @attrs.key?(name.to_s) || super
      end

      def wrap(value)
        case value
        when Hash then Resource.new(value)
        when Array then value.map { |element| wrap(element) }
        else value
        end
      end
    end
  end
end
