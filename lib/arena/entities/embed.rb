require 'arena/entity'
require 'arena/entities/version'

module Arena
  class Entity
    class Embed < Arena::Entity
      attr_reader :embed, :url, :type, :title, :author_name, :author_url,
        :source_url, :thumbnail_url, :width, :height, :html
    end
  end
end