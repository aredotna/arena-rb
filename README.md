# Arena

[![Gem Version](https://badge.fury.io/rb/arena.svg)](https://rubygems.org/gems/arena)
[![Test](https://github.com/aredotna/arena-rb/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/aredotna/arena-rb/actions/workflows/test.yml)
[![Lint](https://github.com/aredotna/arena-rb/actions/workflows/lint.yml/badge.svg?branch=master)](https://github.com/aredotna/arena-rb/actions/workflows/lint.yml)

A Ruby client for the [Are.na API](https://www.are.na/developers).

## Installation

Add to your Gemfile and run `bundle install`.

```ruby
gem 'arena'
```

Or install it with `gem install arena`.

## Usage

Use the v3 API via `Arena.v3`, see [Are.na API v3](https://www.are.na/developers/explore) and its [OpenAPI spec](https://api.are.na/v3/openapi.json).

```ruby
require 'arena'

channel = Arena.v3.channel('arena-influences')
channel.title      # => "Arena Influences"
channel.owner.slug # => "are-na-team"

contents = Arena.v3.channel_contents('arena-influences', sort: 'created_at_desc', per: 10)
contents.each do |connectable|
  puts "#{connectable.type}: #{connectable.title} (connected at #{connectable.connection.connected_at})"
end
contents.meta.next_page # => 2
contents.more?          # => true
```

Responses are `Arena::V3::Resource` objects whose attributes are readable as methods or with `[]`. Lists are an enumerable `Arena::V3::Collection` with `data` and `meta`. Errors raise `Arena::V3::Error` subclasses, such as `Arena::V3::NotFoundError`, `Arena::V3::UnauthorizedError` and `Arena::V3::RateLimitError`, with `status`, `body` and `headers`.

## Configuration

Unauthenticated requests are limited to 30 per minute. Authenticate with a personal access token from [are.na/settings](https://www.are.na/settings) or a user's OAuth token for higher limits and for private content, search (Premium only) and writes.

```ruby
Arena.configure do |config|
  config.access_token = 'token'
  config.user_agent = 'MyApp/1.0 (+https://example.com)'
end

Arena.v3.me.slug
Arena.v3.create_block(value: 'https://example.com', channel_ids: [123]) # requires the write scope
```

Pass options to `Arena.v3` to override the global configuration, e.g. `Arena.v3(access_token: user_token).me`.

| Setting              | Default                                                    | Description                                       |
|----------------------|------------------------------------------------------------|---------------------------------------------------|
| `access_token`       | `ENV['ARENA_ACCESS_TOKEN']`                                | Personal access or OAuth token, sent as `Bearer`. |
| `application_id`     | `ENV['ARENA_CLIENT_ID']`                                   | OAuth application client ID.                      |
| `application_secret` | `ENV['ARENA_CLIENT_SECRET']`                               | OAuth application client secret.                  |
| `auth_token`         | `ENV['ARENA_AUTH_TOKEN']`                                  | Legacy `X-AUTH-TOKEN`, used without an access token. |
| `user_agent`         | `arena-rb/<version> (+https://github.com/aredotna/arena-rb)` | `User-Agent` header, identify your application.   |
| `base_domain`        | `api.are.na`                                               | API host.                                         |

Register an OAuth application at [are.na/oauth/applications](https://www.are.na/oauth/applications), then use `Arena.v3.oauth_token(grant_type: 'authorization_code', code: code, redirect_uri: redirect_uri)` to exchange an authorization code for a user token.

## Legacy v2 API

Are.na is winding down the v2 API, and some of its endpoints, such as `Arena.channel_feed` and `Arena.user_feed`, already return `410 Gone`. The v2 client is still available for the remaining endpoints, e.g. `Arena.channel('arena-influences').contents` or `Arena.search('brutalism')`, but new code should use `Arena.v3`.

## Contributing

See [CHANGELOG](CHANGELOG.md) for changes. Run `bundle install` and `bundle exec rake` to run RuboCop and the tests.

## License

[MIT](LICENSE)
