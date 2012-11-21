require 'arena/entity'

module Arena
  class Entity
    class Provider < Arena::Entity
      attr_reader :name, :url
    end
  end
end
