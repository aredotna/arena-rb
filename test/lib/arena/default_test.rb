# frozen_string_literal: true

require_relative '../../test_helper'

describe Arena::Default do
  def with_env(env)
    previous = env.keys.to_h { |key| [key, ENV.fetch(key, nil)] }
    env.each { |key, value| ENV[key] = value }
    yield
  ensure
    previous.each { |key, value| ENV[key] = value }
  end

  it 'reads credentials from ARENA_ environment variables' do
    with_env(
      'ARENA_CLIENT_ID' => 'id',
      'ARENA_CLIENT_SECRET' => 'secret',
      'ARENA_ACCESS_TOKEN' => 'access',
      'ARENA_AUTH_TOKEN' => 'auth'
    ) do
      assert_equal 'id', Arena::Default.application_id
      assert_equal 'secret', Arena::Default.application_secret
      assert_equal 'access', Arena::Default.access_token
      assert_equal 'auth', Arena::Default.auth_token
    end
  end

  it 'does not use the application secret as an access token' do
    with_env('APPLICATION_SECRET' => 'secret', 'ARENA_ACCESS_TOKEN' => nil) do
      assert_nil Arena::Default.access_token
    end
  end

  it 'defaults to no credentials' do
    with_env(%w[ARENA_CLIENT_ID ARENA_CLIENT_SECRET ARENA_ACCESS_TOKEN ARENA_AUTH_TOKEN].to_h { |key| [key, nil] }) do
      assert_nil Arena::Default.application_id
      assert_nil Arena::Default.application_secret
      assert_nil Arena::Default.access_token
      assert_nil Arena::Default.auth_token
    end
  end
end
