require 'arena/creatable'
require 'arena/entity'
require 'arena/entities/version'

module Arena
  class Entity
    class Image < Arena::Entity
      include Arena::Creatable

      attr_reader :filename, :content_type

      %w(thumb square display large original).each do |method|
        define_method method do
          instance_variable_set("@#{method}", Arena::Entity::Version.new(@attrs[method])) unless instance_variable_get "@#{method}"
          instance_variable_get "@#{method}"
        end
      end
    end
  end
end
