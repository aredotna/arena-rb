require 'arena/entity'

module Arena
  class Entity
    class Version < Arena::Entity
      attr_reader :url, :file_size, :file_display
    end
  end
end
