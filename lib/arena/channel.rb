require 'arena/base'
require 'arena/creatable'
require 'arena/user'
require 'arena/block'

module Arena
  class Channel < Arena::Base
    include Arena::Creatable

    attr_reader :id, :title, :published, :open, :collaboration,
      :slug, :length, :kind, :status, :user_id, :total_pages,
      :current_page, :per, :follower_count

    def user
      @user ||= Arena::User.new(@attrs['user'])
    end

    def _class
      @attrs['class']
    end

    def _base_class
      @attrs['base_class']
    end

    def contents
      @contents ||= @attrs['contents'].collect { |object| "Arena::#{object['class']}".constantize.new(object) }
    end

    def collaborators
      @collaborators ||= @attrs['collaborators'].collect { |user| Arena::User.new(user) }
    end
    
  end
end
