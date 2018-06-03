require_relative '../../test_helper'

describe Arena do
  describe 'channel', :vcr do
    it 'returns a channel' do
      assert_kind_of Arena::Channel, Arena.channel('delightfully-absurd')
    end
  end
end
