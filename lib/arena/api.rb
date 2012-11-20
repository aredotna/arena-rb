require 'arena/channel'

module Arena
  module API
    def channels(options={})
      get "/channels", options
    end

    def channel(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}", options)
    end

    def channel_thumb(id, options={})
      object_from_response(Arena::Channel, :get, "/channels/#{id}/thumb", options)
    end

    def channel_channels(id, options={})
      get "/channels/#{id}/channels", options
    end

    def block(id, options={})
      get "/blocks/#{id}", options
    end

    def user(id, options={})
      object_from_response(Arena::User, :get, "/users/#{id}", options)
    end

    def user_channels(id, options={})
      get "/users/#{id}", options
    end

    def search(query, option={})
      get "/search?q=#{query}", options
    end

  private

    def object_from_response(klass, request_method, url, options={})
      response = send(request_method.to_sym, url, options)
      klass.new(response)
    end
  end
end
