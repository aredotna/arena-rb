require "arena/base"
require "arena/story"
require "arena/group"

module Arena
  class Feed < Arena::Base
    attr_reader :type, :limit, :total, :offset, :range_start, :range_end

    def stories
      @stories ||= @attrs["items"].collect { |item| Arena::Story.new(item) } if stories?
    end
    
    alias items stories

    def groups
      if stories?
        groups = items.group_by do |item|
          target = "#{item.target.id}_" if !item.target.nil?

          "#{item.user.id}_#{target}#{item.action.gsub(' ', '_')}"
        end

        @groups ||=
          groups.collect { |key, stories| Arena::Group.new(key, stories) }.
            sort_by { |group| group.summary.indicative.created_at }.reverse!
      end
    end

  private

    def stories?
      !@attrs["items"].nil?
    end

  end # Feed
end # Arena