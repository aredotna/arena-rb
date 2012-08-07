require 'arena/configurable'
require 'httparty'
require 'json'

module Arena

  class Client
    include HTTParty
    include Arena::Configurable

    def initialize(options={})
      Arena::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Arena.instance_variable_get(:"@#{key}"))
      end
    end

    # Wrapper for v1
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

    def get_json(path, options)
      JSON.parse(
          (self.class.get "http://#{@base_domain}/api/#{@api_version}#{path}", options).body
        )
    end
  end

end
