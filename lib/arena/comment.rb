require "arena/base"
require "arena/user"
require "arena/creatable"

module Arena
  class Comment < Arena::Base
    include Arena::Creatable

    attr_reader :id, :commentable_id, :commentable_type, :body

    def _class
      @_class ||= @attrs["class"]
    end

    def user
      @user ||= Arena::User.new(@attrs['user'])
    end
  end
end
