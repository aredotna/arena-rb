require 'time'
require 'arena/entity'
require 'arena/entities/version'

module Arena
  class Entity
    class Image < Arena::Entity
      attr_reader :filename, :content_type

      def updated_at
        @updated_at ||= Time.parse(@attrs[:updated_at]) if updated?
      end

      %w(thumb display original).each do |method|
        define_method method do
          instance_variable_set("@#{method}", Arena::Entity::Version.new(@attrs.dup[method])) unless instance_variable_get "@#{method}"
          instance_variable_get "@#{method}"
        end
      end

    private
      
      def updated?
        !@attrs[:created_at].nil?
      end

    end
  end
end
