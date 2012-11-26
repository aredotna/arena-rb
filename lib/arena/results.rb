require 'arena/base'
require 'arena/channel'

module Arena
  class Results < Arena::Base
    attr_reader :length, :total_pages, :current_page, :per
  end

  class ChannelResults < Results
    def channels
      @channels ||= @attrs.dup['channels'].collect { |channel| Arena::Channel.new(channel) }
    end
  end
end