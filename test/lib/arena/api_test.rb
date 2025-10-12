# frozen_string_literal: true

require_relative '../../test_helper'

describe Arena do
  describe 'channel', :vcr do
    it 'returns a channel' do
      assert_kind_of Arena::Channel, Arena.channel('delightfully-absurd')
    end

    it 'handles a 403 error' do
      assert_raises StandardError do
        Arena.channel('delightfully-absurd')
      end
    end

    it 'handles a 400 error that returns JSON' do
      error = assert_raises StandardError do
        Arena.channel('delightfully-absurd')
      end
      assert_equal '400: Internal Server Error - Something went wrong.', error.message
    end
  end
end
