require "arena/story"
require "arena/summary"

module Arena
  class Group
    attr_reader :id, :stories

    def initialize(id, stories)
      @id = id
      @stories = stories.sort_by(&:created_at)
    end

    def created_at
      @created_at ||= stories.first.created_at
    end

    def summary
      @summary ||= Arena::Summary.new(stories)
    end
  end # Group
end # Arena
