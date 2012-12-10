require 'arena/core_ext/string'
require 'arena/base'
require 'arena/channel'
require 'arena/user'
require 'arena/block'

module Arena
  class SearchResults < Arena::Base
    def term
      @attrs['term'] unless @attrs['term'].nil?
    end

    %w(user channel block).each do |method|
      define_method "#{method}s" do
        instance_variable_set("@#{method}s",
            @attrs["#{method}s"].collect { |element| "Arena::#{method.capitalize}".constantize.new(element) }
          ) unless instance_variable_get "@#{method}s"
        instance_variable_get "@#{method}s"
      end
    end
  end
end