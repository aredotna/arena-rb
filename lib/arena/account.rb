require "arena/base"
require "arena/user"

module Arena
  class Account < Arena::Base
    def user
      @user ||= Arena::User.new(@attrs["user"])
    end

    def channels
      @channels ||= @attrs["channels"].collect { |channel| Arena::Channel.new(channel) }
    end

    def help_channels
      @help_channels ||= @attrs["help_channels"].collect { |channel| Arena::Channel.new(channel) }
    end

    def following_channel_ids
      @following_channel_ids ||= @attrs["following_ids"]["channels"]
    end

    def following_user_ids
      @following_user_ids ||= @attrs["following_ids"]["users"]
    end
  end
end
