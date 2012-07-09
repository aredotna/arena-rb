require 'arena/configurable'
require 'httparty'
require 'json'

module Arena

  class Client
    include HTTParty
    include Arena::Configurable
    
    class << self

      def channel(identifier, options={})
        get_json "/channels/#{identifier}", options
      end

      def users_channels(id, options={})
        get_json "/channels?user=#{id}", options
      end

      def block(id, options={})
        get_json "/blocks/#{id}", options
      end

      def blocks(identifier, options={})
        get_json "/blocks?channel=#{identifier}", options
      end

      private

      # Perform HTTP GET request and parse the response body
      def get_json(path, options)
        JSON.parse(
            (get "#{Arena::Configurable::BASE_URL}#{path}", options).body
          )
      end
    end

  end

end
