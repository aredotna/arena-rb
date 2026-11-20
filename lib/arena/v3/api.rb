# frozen_string_literal: true

require 'arena/v3/resource'
require 'arena/v3/collection'

module Arena
  module V3
    # Methods for the Are.na v3 API, see https://www.are.na/developers/explore.
    #
    # List methods accept page and per (max 100), as well as endpoint-specific options such as sort or type,
    # and return an Arena::V3::Collection. Other methods return an Arena::V3::Resource.
    module API
      # Checks that the API is reachable.
      def ping
        resource(:get, '/ping')
      end

      # The authenticated user.
      def me
        resource(:get, '/me')
      end

      # The authenticated user's feed, cursor-paginated with limit, next and prev.
      def me_feed(options = {})
        collection(:get, '/me/feed', options)
      end

      # The authenticated user's notifications.
      def me_notifications(options = {})
        collection(:get, '/me/notifications', options)
      end

      # A channel by id or slug.
      def channel(id)
        resource(:get, "/channels/#{escape(id)}")
      end

      # Blocks and channels connected to a channel, sorted with sort (e.g. created_at_desc, position_asc).
      def channel_contents(id, options = {})
        collection(:get, "/channels/#{escape(id)}/contents", options)
      end

      # Channels a channel is connected to.
      def channel_connections(id, options = {})
        collection(:get, "/channels/#{escape(id)}/connections", options)
      end

      # Users following a channel.
      def channel_followers(id, options = {})
        collection(:get, "/channels/#{escape(id)}/followers", options)
      end

      # Creates a channel, e.g. create_channel(title: 'Ideas', visibility: 'private').
      def create_channel(options = {})
        resource(:post, '/channels', options)
      end

      # Updates a channel.
      def update_channel(id, options = {})
        resource(:put, "/channels/#{escape(id)}", options)
      end

      # Deletes a channel.
      def delete_channel(id)
        request(:delete, "/channels/#{escape(id)}")
        nil
      end

      # A block by id.
      def block(id)
        resource(:get, "/blocks/#{escape(id)}")
      end

      # Channels a block is connected to.
      def block_connections(id, options = {})
        collection(:get, "/blocks/#{escape(id)}/connections", options)
      end

      # Comments on a block.
      def block_comments(id, options = {})
        collection(:get, "/blocks/#{escape(id)}/comments", options)
      end

      # Creates a block from text or a URL and connects it, e.g. create_block(value: 'Hello', channel_ids: [123]).
      def create_block(options = {})
        resource(:post, '/blocks', options)
      end

      # Updates a block.
      def update_block(id, options = {})
        resource(:put, "/blocks/#{escape(id)}", options)
      end

      # Comments on a block, e.g. create_comment(123, body: 'Nice!').
      def create_comment(block_id, options = {})
        resource(:post, "/blocks/#{escape(block_id)}/comments", options)
      end

      # Deletes a comment.
      def delete_comment(id)
        request(:delete, "/comments/#{escape(id)}")
        nil
      end

      # A connection by id.
      def connection(id)
        resource(:get, "/connections/#{escape(id)}")
      end

      # Connects a block or a channel to channels,
      # e.g. create_connection(connectable_id: 1, connectable_type: 'Block', channel_ids: [123]).
      def create_connection(options = {})
        resource(:post, '/connections', options)
      end

      # Removes a connection.
      def delete_connection(id)
        request(:delete, "/connections/#{escape(id)}")
        nil
      end

      # A user by id or slug.
      def user(id)
        resource(:get, "/users/#{escape(id)}")
      end

      # Blocks and channels created by a user, newest first by default, filter with type (e.g. Channel, Image).
      def user_contents(id, options = {})
        collection(:get, "/users/#{escape(id)}/contents", options)
      end

      # Users following a user.
      def user_followers(id, options = {})
        collection(:get, "/users/#{escape(id)}/followers", options)
      end

      # Channels, users and groups a user follows.
      def user_following(id, options = {})
        collection(:get, "/users/#{escape(id)}/following", options)
      end

      # Groups a user belongs to.
      def user_groups(id, options = {})
        collection(:get, "/users/#{escape(id)}/groups", options)
      end

      # A group by id or slug.
      def group(id)
        resource(:get, "/groups/#{escape(id)}")
      end

      # Blocks and channels in a group.
      def group_contents(id, options = {})
        collection(:get, "/groups/#{escape(id)}/contents", options)
      end

      # Users following a group.
      def group_followers(id, options = {})
        collection(:get, "/groups/#{escape(id)}/followers", options)
      end

      # Members of a group.
      def group_members(id, options = {})
        collection(:get, "/groups/#{escape(id)}/members", options)
      end

      # Searches blocks, channels, users and groups, e.g. search('brutalism', type: 'Channel').
      # Requires authentication with a Premium account.
      def search(query, options = {})
        collection(:get, '/search', options.merge(query: query))
      end

      # Obtains an OAuth access token,
      # e.g. oauth_token(grant_type: 'authorization_code', code: '...', redirect_uri: '...').
      # The client id and secret default to the configured application_id and application_secret.
      def oauth_token(options = {})
        resource(:post_form, '/oauth/token', {
          client_id: @application_id,
          client_secret: @application_secret
        }.merge(options))
      end

      # Obtains an access token for the application itself with the client_credentials grant.
      def client_credentials_token(options = {})
        oauth_token({ grant_type: 'client_credentials' }.merge(options))
      end

      private

      def resource(method, path, options = {})
        Resource.new(request(method, path, options))
      end

      def collection(method, path, options = {})
        Collection.new(request(method, path, options))
      end

      def escape(id)
        URI.encode_www_form_component(id.to_s)
      end
    end
  end
end
