require "arena/configurable"
require "arena/error"
require "arena/api"
require "httparty"
require "json"

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
    #
    %w(get post put delete).each do |method|
      define_method method do |path, options={}|
        options = { query: options, headers: set_headers }

        request(__method__, path, options)
      end
    end

  private

    def set_headers
      if !@access_token.nil?
        { "Authorization" => "Bearer #{@access_token}" }
      elsif !@auth_token.nil?
        { "X-AUTH-TOKEN" => @auth_token }
      else
        { }
      end
    end

    def error?(response)
      response.code != 200
    end

    def error_message(response)
      "#{response['code']}: #{response['message']} - #{response['description']}"
    end

    def request(method, path, options)
      response = self.class.send(method, "http://#{@base_domain}/#{@api_version}#{path}", options)
      parsed = JSON.parse(response.body)

      raise Arena::Error.new(error_message(parsed)) if error?(response)

      parsed
    rescue JSON::ParserError, TypeError
      nil
    end
  end
end
