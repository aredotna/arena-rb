require 'arena/user'
require 'arena/creatable'

module Arena
  class Channel
    include Arena::Creatable

    attr_reader :id, :title, :created_at, :updated_at, :published, 
      :open, :collaboration, :slug, :length, :kind, :status, :user_id,
      :user, :total_pages, :current_page,
      :per, :follower_count, :contents, :collaborators

    def initialize(attrs={})
      @attrs = attrs
    end

    def user
      @user ||= Arena::User.new(@attrs.dup['user'])
    end

    def _class
      @attrs.dup['class']
    end

    def _base_class
      @attrs.dup['base_class']
    end
  end
end
