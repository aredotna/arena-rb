require 'arena/base'
require 'arena/entity'
require 'arena/entities/source'
require 'arena/entities/image'
require 'arena/entities/attachment'
require 'arena/entities/embed'
require 'arena/creatable'

module Arena
  class Block < Arena::Base
    include Arena::Creatable

    attr_reader :id, :title, :generated_title, :state, :comment_count, :content,
      :content_html, :description, :description_html, :position, :selected,
      :connection_id, :connected_by_user_id, :connected_by_username

    def user
      @user ||= Arena::User.new(@attrs['user'])
    end

    def _class
      @_class ||= @attrs['class']
    end

    def _base_class
      @_base_class ||= @attrs['base_class']
    end

    def source
      @source ||= Arena::Entity::Source.new(@attrs['source'])
    end

    def image
      @image ||= Arena::Entity::Image.new(@attrs['image']) if has_image?
    end
    
    def attachment
      @attachment ||= Arena::Entity::Attachment.new(@attrs['attachment']) if has_attachment?
    end

    def embed
      @embed ||= Arena::Entity::Embed.new(@attrs['embed']) if has_embed?
    end

    def connections
      @connections ||= @attrs['connections'].collect { |channel| Arena::Channel.new(channel) }
    end

    def connected_at
      @connected_at ||= Time.parse(@attrs['connected_at']) if !@attrs['connected_at'].nil?
    end

    # Detect optional portions of the response
    [:image, :attachment, :embed].each do |kind|
      define_method "has_#{kind}?" do
        !@attrs[kind.to_s].nil?
      end
    end

  end

  class Text < Block; end
  class Image < Block; end
  class Link < Block; end
  class Media < Block; end
  class Attachment < Block; end
end