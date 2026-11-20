# frozen_string_literal: true

require 'httparty'
require 'json'
require 'uri'
require 'arena/configurable'
require 'arena/v3/error'
require 'arena/v3/api'

module Arena
  module V3
    # A client for the Are.na v3 API, configured like Arena::Client.
    #
    #   client = Arena::V3::Client.new(access_token: 'token')
    #   client.channel_contents('arena-influences', sort: 'created_at_desc', per: 10).each do |connectable|
    #     puts connectable.title
    #   end
    class Client
      include HTTParty
      include Arena::Configurable
      include Arena::V3::API

      API_VERSION = 'v3'

      def initialize(options = {})
        Arena::Configurable.keys.each do |key| # rubocop:disable Style/HashEachMethods -- keys is an Array
          instance_variable_set(:"@#{key}", options.key?(key) ? options[key] : Arena.instance_variable_get(:"@#{key}"))
        end
      end

      private

      def request(method, path, options = {})
        response = self.class.send(http_method(method), url(path), request_options(method, options))
        parsed = parse(response)
        raise_error(response, parsed) unless response.success?

        parsed
      end

      def http_method(method)
        method == :post_form ? :post : method
      end

      def url(path)
        "https://#{@base_domain}/#{API_VERSION}#{path}"
      end

      def request_options(method, options)
        options = options.compact
        headers = request_headers

        case method
        when :get, :delete
          { headers: headers, query: options.empty? ? nil : options }.compact
        when :post_form
          { headers: headers, body: options }
        else
          { headers: headers.merge('Content-Type' => 'application/json'), body: JSON.generate(options) }
        end
      end

      def request_headers
        headers = { 'Accept' => 'application/json' }
        headers['User-Agent'] = @user_agent if @user_agent
        if @access_token
          headers['Authorization'] = "Bearer #{@access_token}"
        elsif @auth_token
          headers['X-AUTH-TOKEN'] = @auth_token
        end
        headers
      end

      def parse(response)
        return unless response.body && !response.body.empty?
        return unless response.content_type.to_s.include?('json')

        JSON.parse(response.body)
      rescue JSON::ParserError
        nil
      end

      def raise_error(response, parsed)
        raise Arena::V3::Error.for(response.code).new(
          error_message(response, parsed),
          status: response.code,
          body: parsed || response.body,
          headers: response.headers.to_h.transform_values { |value| value.is_a?(Array) ? value.first : value }
        )
      end

      def error_message(response, parsed)
        if parsed.is_a?(Hash) && (parsed['error'] || parsed['message'])
          details = parsed['details'].is_a?(Hash) ? parsed['details']['message'] : nil
          details ||= parsed['description']
          [[response.code, parsed['error'] || parsed['message']].join(': '), details].compact.join(' - ')
        else
          "#{response.code}: #{response.body.to_s.empty? ? 'Unexpected Error' : response.body}"
        end
      end
    end
  end
end
