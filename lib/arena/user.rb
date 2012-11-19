require 'arena/base'
require 'arena/creatable'

module Arena
  class User < Arena::Base
    include Arena::Creatable

    attr_reader :id, :slug, :username, :first_name, :last_name,
    :full_name, :avatar, :email, :channel_count, :following_count,
    :profile_id, :follower_count, :initials

    def _class
      @attrs.dup['class']
    end
  end
end
