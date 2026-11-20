# frozen_string_literal: true

require 'arena/v3/resource'

module Arena
  module V3
    # A list returned by the v3 API, with its items in data and pagination in meta.
    #
    # Page-based lists have meta.current_page, meta.next_page and
    # meta.has_more_pages, cursor-based lists (/v3/me/feed) have
    # meta.next_cursor and meta.has_more.
    class Collection < Resource
      include Enumerable

      def data
        @data ||= Array(@attrs['data']).map { |element| Resource.new(element) }
      end

      def meta
        @meta ||= Resource.new(@attrs['meta'])
      end

      def each(&block)
        data.each(&block)
      end

      def size
        data.size
      end

      alias length size

      def empty?
        data.empty?
      end

      def more?
        meta.key?('has_more_pages') ? meta.has_more_pages == true : meta['has_more'] == true
      end
    end
  end
end
