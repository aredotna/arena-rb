require "arena/base"
require "arena/creatable"
require "arena/entity"
require "arena/entities/avatar"

module Arena
  class User < Arena::Base
    include Arena::Creatable

    attr_reader :id, :slug, :username, :first_name, :last_name,
      :full_name, :avatar, :email, :channel_count, :following_count,
      :profile_id, :follower_count, :initials

    def _class
      @attrs["class"]
    end

    def avatar_image
      Arena::Entity::Avatar.new(@attrs["avatar_image"]) if !@attrs["avatar_image"].nil?
    end
  end # User
end # Arena
