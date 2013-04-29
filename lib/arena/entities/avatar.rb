require "arena/entity"

module Arena
  class Entity
    class Avatar < Arena::Entity
      attr_reader :thumb, :display

      def custom(size=40)
        thumb.gsub("s=40", "s=#{size}")
      end
    end # Avatar
  end # Entity
end # Arena
