# frozen_string_literal: true

require 'arena/base'
require 'arena/channel'
require 'arena/user'
require 'arena/block'

module Arena
  class SearchResults < Arena::Base
    attr_reader :term,
                :per,
                :current_page,
                :total_pages,
                :length,
                :authenticated

    %w[user channel block].each do |method|
      define_method "#{method}s" do
        unless instance_variable_get "@#{method}s"
          instance_variable_set("@#{method}s",
                                @attrs["#{method}s"].collect do |element|
                                  Arena::Base.class_for(method.capitalize).new(element)
                                end)
        end
        instance_variable_get "@#{method}s"
      end
    end
  end
end
