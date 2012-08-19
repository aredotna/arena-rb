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

    def channels(options={})
      get_json "/channels", options
    end

    def channel(id, options={})
      get_json "/channels/#{id}", options
    end

    def block(id, options={})
      get_json "/blocks/#{id}", options
    end

    def user(id, options={})
      get_json "/users/#{id}", options
    end

    def user_channels(id, options={})
      get_json "/users/#{id}", options
    end

    def search(query, option={})
      get_json "/api/v2/search?q=#{query}", options
    end

    private

    def get_json(path, opts)
      options = { :query => opts }
      JSON.parse(
          (self.class.get "http://#{@base_domain}/api/#{@api_version}#{path}", options).body
        )
    end
  end

end


class Hash
  def to_openstruct
         mapped = {}
         each{ |key,value| mapped[key] = value.to_openstruct }
         OpenStruct.new(mapped)
  end
end