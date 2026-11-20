# frozen_string_literal: true

require_relative '../../../test_helper'

describe Arena::V3::Client do
  let(:client) { Arena.v3 }

  describe 'channel' do
    it 'returns a channel' do
      channel = client.channel('arena-influences')

      assert_kind_of Arena::V3::Resource, channel
      assert_equal 275, channel.id
      assert_equal 'Channel', channel.type
      assert_equal 'Arena Influences', channel.title
      assert_equal 'are-na-team', channel.owner.slug
    end

    it 'raises a not found error' do
      error = assert_raises Arena::V3::NotFoundError do
        client.channel('arena-rb-does-not-exist')
      end

      assert_kind_of Arena::Error, error
      assert_equal 404, error.status
      assert_equal '404: Not Found - The resource you are looking for does not exist.', error.message
    end
  end

  describe 'channel_contents' do
    it 'returns contents newest connections first' do
      contents = client.channel_contents('arena-influences', sort: 'created_at_desc', per: 2)

      assert_kind_of Arena::V3::Collection, contents
      assert_equal 2, contents.size
      assert_equal 1, contents.meta.current_page
      assert_predicate contents, :more?
      connected_at = contents.map { |connectable| connectable.connection.connected_at }

      assert_equal connected_at.sort.reverse, connected_at
    end
  end

  describe 'user' do
    it 'returns a user' do
      user = client.user('cab')

      assert_equal 15, user.id
      assert_equal 'Charles Broskoski', user.name
    end
  end

  describe 'user_contents' do
    it 'returns channels' do
      contents = client.user_contents('cab', type: 'Channel', per: 2)

      assert_equal 2, contents.size
      assert(contents.all? { |connectable| connectable.type == 'Channel' })
    end
  end

  describe 'block' do
    it 'returns a block' do
      block = client.block(9_613_792)

      assert_equal 'Image', block.type
      assert_equal 'Block', block.base_type
      assert_match %r{\Ahttps://}, block.image.src
    end
  end

  describe 'search' do
    it 'requires authentication' do
      error = assert_raises Arena::V3::UnauthorizedError do
        client.search('david')
      end

      assert_equal '401: Unauthorized - Authentication required', error.message
    end
  end

  describe 'requests' do
    it 'sends a user agent and a bearer token' do
      stub = stub_request(:get, 'https://api.are.na/v3/me').with(
        headers: {
          'Authorization' => 'Bearer token',
          'User-Agent' => "arena-rb/#{Arena::VERSION} (+https://github.com/aredotna/arena-rb)",
          'Accept' => 'application/json'
        }
      ).to_return(status: 200, body: '{"id":1,"slug":"me"}', headers: { 'Content-Type' => 'application/json' })

      assert_equal 'me', Arena.v3(access_token: 'token').me.slug
      assert_requested stub
    end

    it 'sends a custom user agent' do
      stub = stub_request(:get, 'https://api.are.na/v3/ping')
             .with(headers: { 'User-Agent' => 'MyApp/1.0' })
             .to_return(status: 200, body: '{"status":"ok"}', headers: { 'Content-Type' => 'application/json' })

      assert_equal 'ok', Arena.v3(user_agent: 'MyApp/1.0').ping.status
      assert_requested stub
    end

    it 'sends query parameters and arrays' do
      stub = stub_request(:get, 'https://api.are.na/v3/search?query=brutalism&type[]=Channel&type[]=User&per=1')
             .to_return(status: 200, body: '{"data":[],"meta":{}}', headers: { 'Content-Type' => 'application/json' })

      assert_empty client.search('brutalism', type: %w[Channel User], per: 1, page: nil)
      assert_requested stub
    end

    it 'escapes ids' do
      stub = stub_request(:get, 'https://api.are.na/v3/channels/a%2Fb')
             .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

      client.channel('a/b')

      assert_requested stub
    end

    it 'posts JSON' do
      stub = stub_request(:post, 'https://api.are.na/v3/blocks')
             .with(
               body: { value: 'https://example.com', channel_ids: [123] }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )
             .to_return(status: 201, body: '{"id":1,"type":"Link"}', headers: { 'Content-Type' => 'application/json' })

      assert_equal 'Link', client.create_block(value: 'https://example.com', channel_ids: [123]).type
      assert_requested stub
    end

    it 'deletes' do
      stub = stub_request(:delete, 'https://api.are.na/v3/connections/1').to_return(status: 204, body: '')

      assert_nil client.delete_connection(1)
      assert_requested stub
    end

    it 'obtains a client credentials token' do
      stub = stub_request(:post, 'https://api.are.na/v3/oauth/token')
             .with(body: { client_id: 'id', client_secret: 'secret', grant_type: 'client_credentials' })
             .to_return(
               status: 200,
               body: '{"access_token":"token","token_type":"Bearer","scope":"read","created_at":1}',
               headers: { 'Content-Type' => 'application/json' }
             )

      token = Arena.v3(application_id: 'id', application_secret: 'secret').client_credentials_token

      assert_equal 'token', token.access_token
      assert_requested stub
    end
  end

  describe 'errors' do
    it 'raises a rate limit error with a reset time' do
      stub_request(:get, 'https://api.are.na/v3/channels/x').to_return(
        status: 429,
        body: '{"error":"Too Many Requests","code":429,"details":{"message":"Rate limit exceeded."}}',
        headers: { 'Content-Type' => 'application/json', 'X-RateLimit-Reset' => '1795205000' }
      )

      error = assert_raises(Arena::V3::RateLimitError) { client.channel('x') }

      assert_equal '429: Too Many Requests - Rate limit exceeded.', error.message
      assert_equal 1_795_205_000, error.reset
    end

    it 'raises a generic error for unknown statuses' do
      stub_request(:get, 'https://api.are.na/v3/channels/x').to_return(status: 500, body: 'Oops')

      error = assert_raises(Arena::V3::Error) { client.channel('x') }

      assert_instance_of Arena::V3::Error, error
      assert_equal '500: Oops', error.message
      assert_equal 'Oops', error.body
    end

    it 'raises an error without a body' do
      stub_request(:get, 'https://api.are.na/v3/channels/x').to_return(status: 503, body: '')

      error = assert_raises(Arena::V3::Error) { client.channel('x') }

      assert_equal '503: Unexpected Error', error.message
    end
  end
end
