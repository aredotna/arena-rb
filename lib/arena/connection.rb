require "arena/base"

module Arena
  class Connection < Arena::Base
    include Arena::Creatable

    attr_reader :id, :position, :selected, :user_id,
      :connectable_id, :connectable_type, :channel_id
  end # Connection
end # Arena
