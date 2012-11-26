require 'arena/base'
require 'arena/creatable'
require 'arena/user'
require 'arena/block'

module Arena
  class Channel < Arena::Base
    include Arena::Creatable

    attr_reader :id, :title, :published, :open, :collaboration,
      :slug, :length, :kind, :status, :user_id, :user, :total_pages,
      :current_page, :per, :follower_count, :collaborators

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
      # TODO: If not present; should make an API request for contents
      @contents ||= @attrs.dup['contents'].collect { |block| Arena::Block.new(block) }
    end
  end
end
