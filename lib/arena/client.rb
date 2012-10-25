require 'arena/configurable'
require 'httparty'
require 'json'
require 'ostruct'

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

    def channel_thumb(id, options={})
      get_json "/channels/#{id}/thumb", options
    end

    def channel_channels(id, options={})
      get_json "/channels/#{id}/channels", options
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
      get_json "/search?q=#{query}", options
    end

    def check_base_path
      "http://#{@base_domain}/#{@api_version}"
    end

    private

    def get_json(path, opts)
      options = { :query => opts }
      parse(path, opts)
    end

    def parse(path, opts)
      to_ostruct(
        JSON.parse(
            (self.class.get "http://#{@base_domain}/#{@api_version}#{path}", options).body
          )
        )
    end

    def to_ostruct(obj)
      if obj.is_a? Hash
        open_struct = OpenStruct.new
        obj.each { |key, value| open_struct.send("#{key}=", to_ostruct(value)) }
        return open_struct
      
      elsif obj.is_a? Array
        obj = obj.map { |value| to_ostruct(value) }
      end

      return obj
    end

  end

end