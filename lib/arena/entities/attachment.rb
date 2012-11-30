require 'arena/entity'
require 'arena/entities/version'

module Arena
  class Entity
    class Attachment < Arena::Entity
      attr_reader :file_name, :file_size, :file_size_display,
        :content_type, :extension, :url
    end
  end
end