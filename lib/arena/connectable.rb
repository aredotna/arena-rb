require 'time'

module Arena
  module Connectable
    attr_reader :connection_id

    def connected_at
      @connected_at ||= Time.parse(@attrs['connected_at']) if connected?
    end

    def connected_by_different_user?
      user.id != connected_by.id
    end

    def connected_by
      @connected_by ||= Arena::User.new({
          'id' => @attrs['connected_by_user_id'],
          'username' => @attrs['connected_by_username'],
          'full_name' => @attrs['connected_by_username']
        })
    end

  private

    def connected?
      !@attrs['connected_at'].nil?
    end

  end
end
