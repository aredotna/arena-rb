require 'arena/user'
require 'arena/block'
require 'arena/channel'
require 'arena/results'
require 'arena/search_results'

module Arena
  module API
    # Returns paginated global list of Channels
    def channels(options={})
      object_from_response(Arena::ChannelResults, :get, "/channels", options)
    end

    # Returns a full Channel representation
    def channel(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}", options)
    end

    # Returns thumbnail representation (first 9 Blocks) for the given Channel
    def channel_thumb(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}/thumb", options)
    end

    # Returns a paginated list of all Channels connected to the given Channel
    def channel_channels(id, options={})
      object_from_response(Arena::ChannelResults, :get, "/channels/#{id}/channels", options)
    end

    # Returns a full Block representation
    def block(id, options={})
      object_from_response(Arena::Block, :get, "/blocks/#{id}", options)
    end

    # Returns a User representation
    def user(id, options={})
      object_from_response(Arena::User, :get, "/users/#{id}", options)
    end

    # Returns a paginated list of all Channels a User has access to
    def user_channels(id, options={})
      object_from_response(Arena::ChannelResults, :get, "/users/#{id}/channels", options)
    end

    # Returns a Search object with an Array for Channels, Blocks and Users
    def search(query, option={})
      object_from_response(Arena::SearchResults, :get, "/search?q=#{query}", options)
    end

  private

    def object_from_response(klass, request_method, url, options={})
      response = send(request_method.to_sym, url, options)
      klass.new(response)
    end

    def collection_from_array(klass, array)
      array.collect { |element| klass.new(element) }
    end

    def collection_from_response(klass, request_method, url, options={}, selector)
      collection_from_array(klass, send(request_method.to_sym, url, options)[selector])
    end

  end
end
