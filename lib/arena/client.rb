require 'arena/configurable'
require 'arena/error'
require 'arena/api'
require 'httparty'
require 'json'

module Arena

  class Client
    include HTTParty
    include Arena::Configurable
    include Arena::API

    def initialize(options={})
      Arena::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Arena.instance_variable_get(:"@#{key}"))
      end
    end

    # Performs HTTP GET POST PUT and DELETE requests
    %w(get post put delete).each do |method|
      define_method method do |path, options={}|
        options = { query: options,
                    headers: { 'Authorization' => "Bearer #{@access_token}" } }
                    
        request(__method__, path, options)
      end
    end

  private

    def request(method, path, options)
      JSON.parse self.class.send(method, "http://#{@base_domain}/#{@api_version}#{path}", options).body
    rescue
      raise Arena::Error
    end

  end

end