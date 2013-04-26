require "arena/base"
require "arena/story"

module Arena
  class Feed < Arena::Base
    attr_reader :type, :limit, :total, :offset, :range_start, :range_end

    def stories
      @attrs["items"].collect { |item| Arena::Story.new(item) }
    end
    
    alias items stories
  end
end