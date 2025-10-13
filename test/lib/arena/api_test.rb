# frozen_string_literal: true

require_relative '../../test_helper'

describe Arena do
  describe 'channel', :vcr do
    it 'returns a channel' do
      assert_kind_of Arena::Channel, Arena.channel('delightfully-absurd')
    end

    it 'handles a 403 error' do
      error = assert_raises Arena::Error do
        Arena.channel('delightfully-absurd')
      end
      assert_equal '403: Forbidden', error.message
    end

    it 'handles a 400 error that returns JSON' do
      error = assert_raises Arena::Error do
        Arena.channel('delightfully-absurd')
      end
      assert_equal '400: Internal Server Error - Something went wrong.', error.message
    end

    it 'handles a 400 error that returns nil' do
      error = assert_raises Arena::Error do
        Arena.channel('delightfully-absurd')
      end
      assert_equal '403: Unexpected Error', error.message
    end
  end
end
