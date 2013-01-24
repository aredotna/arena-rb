require 'time'

module Arena
  module Connectable

    %w(position selected connection_id).each do |method|
      define_method method do
        instance_variable_set("@#{method}", @attrs[method]) unless instance_variable_get "@#{method}"
        instance_variable_get "@#{method}"
      end
    end

    %w(image text link media attachment channel).each do |kind|
      define_method "is_#{kind}?" do
        _class == kind.to_s.capitalize
      end
    end

    def is_block?
      _base_class == "Block"
    end

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
