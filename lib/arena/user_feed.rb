require "arena/base"
require "arena/story"

module Arena
  class UserFeed < Arena::Base
    attr_reader :type, :limit, :total, :offset, :range_start, :range_end

    def stories
      @stories ||= @attrs["items"].collect { |item| Arena::Story.new(item) } if stories?
    end

    alias items stories

  private

    def stories?
      !@attrs["items"].nil?
    end

  end # Feed
end # Arena
