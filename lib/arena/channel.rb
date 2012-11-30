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
      @user ||= Arena::User.new(@attrs.dup['user'])
    end

    def _class
      @attrs.dup['class']
    end

    def _base_class
      @attrs.dup['base_class']
    end

    def contents
      @contents ||= @attrs['contents'].collect do |object|
        "Arena::#{object['class']}".constantize.new(object)
      end
    end

    def collaborators
      @collaborators ||= @attrs['collaborators'].collect { |user| Arena::User.new(user) }
    end
    
  end
end
