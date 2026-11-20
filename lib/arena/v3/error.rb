# frozen_string_literal: true

require 'arena/error'

module Arena
  module V3
    # Raised when the v3 API returns an error, e.g. "404: Not Found - The resource you are looking for does not exist.".
    class Error < Arena::Error
      attr_reader :status, :body, :headers

      def initialize(message = nil, status: nil, body: nil, headers: nil)
        super(message)
        @status = status
        @body = body
        @headers = headers || {}
      end

      def self.for(status)
        ERRORS.fetch(status, self)
      end
    end

    class BadRequestError < Error; end
    class UnauthorizedError < Error; end
    class ForbiddenError < Error; end
    class NotFoundError < Error; end
    class GoneError < Error; end

    # Raised on 429 Too Many Requests, reset is the Unix timestamp when the rate limit resets.
    class RateLimitError < Error
      def reset
        value = headers['x-ratelimit-reset']
        value&.to_i
      end
    end

    class Error
      ERRORS = {
        400 => BadRequestError,
        401 => UnauthorizedError,
        403 => ForbiddenError,
        404 => NotFoundError,
        410 => GoneError,
        429 => RateLimitError
      }.freeze
    end
  end
end
