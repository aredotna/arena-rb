require 'arena/entity'
require 'arena/entities/provider'

module Arena
  class Entity
    class Source < Arena::Entity
      attr_reader :url

      def provider
        @provider ||= Arena::Entity::Provider.new(@attrs['provider'])
      end
    end
  end
end
