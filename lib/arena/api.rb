require 'arena/user'
require 'arena/block'
require 'arena/channel'
require 'arena/results'
require 'arena/search_results'
require 'arena/account'

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

    # Posts a block to a channel
    def channel_add_block(id, options={})
      object_from_response(Arena::Block, :post, "/channels/#{id}/blocks", options)
    end

    # Remove a block from channel (destroy connection)
    def channel_remove_block(channel_id, id, options={})
      send(:delete, "/channels/#{channel_id}/blocks/#{id}", options)
    end

    # Select a block within the context of a channel
    def channel_toggle_block_selection(id, options={})
      send(:put, "/connections/#{id}/selection", options)
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

    # Returns a paginated list of all public Channels a User has access to
    def user_channels(id, options={})
      object_from_response(Arena::ChannelResults, :get, "/users/#{id}/channels", options)
    end

    # Full representation of the account endpoint
    def account(options={})
      object_from_response(Arena::Account, :get, "/accounts", options)
    end

    # All of the authenticated user's Channels
    def account_channels(options={})
      object_from_response(Arena::ChannelResults, :get, "/accounts/channels", options)
    end

    # Returns the authenticated user's settings
    def settings(options={})
      object_from_response(Arena::User, :get, "/accounts/settings", options)
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
