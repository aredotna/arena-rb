require "arena/base"
require "arena/creatable"
require "arena/user"
require "arena/block"
require "arena/channel"
require "arena/connection"

module Arena
  class Story < Arena::Base
    include Arena::Creatable

    attr_reader :id, :action, :bulletin_id, :connector, :created_at

    def user
      @user ||= Arena::User.new(@attrs["user"])
    end

    %w(item target parent).each do |method|
      define_method method do
        if !@attrs[method].nil?
          type = "#{method}_type"

          instance_variable_set("@#{method}",
              "Arena::#{@attrs[type]}".constantize.new(@attrs[method])
            ) unless instance_variable_get "@#{method}"
          instance_variable_get "@#{method}"
        end
      end
    end
  end # Story
end # Arena