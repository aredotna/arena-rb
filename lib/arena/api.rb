require 'arena/user'
require 'arena/block'
require 'arena/channel'
require 'arena/results'
require 'arena/search_results'

module Arena
  module API
    def channels(options={})
      object_from_response(Arena::ChannelResults, :get, "/channels", options)
    end

    def channel(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}", options)
    end

    def channel_thumb(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}/thumb", options)
    end

    def channel_channels(id, options={})
      collection_from_response(Arena::Channel, :get, "/channels/#{id}/channels", options, "channels")
    end

    def block(id, options={})
      object_from_response(Arena::Block, :get, "/blocks/#{id}", options)
    end

    def user(id, options={})
      object_from_response(Arena::User, :get, "/users/#{id}", options)
    end

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
