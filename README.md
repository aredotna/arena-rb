[![test](https://github.com/aredotna/arena-rb/actions/workflows/test.yml/badge.svg)](https://github.com/aredotna/arena-rb/actions/workflows/test.yml)

# Arena

## Installation

Add this line to your application's Gemfile:

    gem 'arena'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arena

## Usage

Are.na is winding down its v2 API, which this gem has historically wrapped (`Arena.channel`, etc.). Use the v3 API via `Arena.v3` for new code, see [Are.na API v3](https://www.are.na/developers/explore).

### v3 API

```ruby
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

Responses are `Arena::V3::Resource` objects whose attributes, as documented in the [OpenAPI spec](https://api.are.na/v3/openapi.json), are readable as methods or with `[]`. Lists are an enumerable `Arena::V3::Collection` with `data` and `meta`. Errors raise `Arena::V3::Error` subclasses, such as `Arena::V3::NotFoundError`, `Arena::V3::UnauthorizedError` and `Arena::V3::RateLimitError`, with `status`, `body` and `headers`.

Unauthenticated requests are limited to 30 per minute. Authenticate with a personal access token from [are.na/settings](https://www.are.na/settings) or a user's OAuth token for higher limits and for private content, search (Premium only) and writes.

```ruby
Arena.configure do |config|
  config.access_token = ENV['ARENA_ACCESS_TOKEN']
  config.user_agent = 'MyApp/1.0 (+https://example.com)'
end

Arena.v3.me.slug
Arena.v3.create_block(value: 'https://example.com', channel_ids: [123]) # requires the write scope
```

Use `Arena.v3.oauth_token` to exchange an authorization code (`grant_type: 'authorization_code'`) for a user token, using the configured `application_id` and `application_secret`.

Pass options to `Arena.v3` to override the global configuration, e.g. `Arena.v3(access_token: user_token).me`.

### v2 API

Register an application at [https://dev.are.na](https://dev.are.na).

### Configure for personal use (optional; be aware this grants access to everything your account has access to)
```ruby
Arena.configure do |config|
    config.access_token = 'XXXXXXXXXXXXX'
end
```

### Simple usage example

```ruby
@channel = Arena.channel(params[:id])
```

```erb
<% @channel.contents.each do |connectable| %>
    <%= connectable.title %>
    <% if connectable.has_image? %>
        <img src="<%= connectable.image.display.url %>" alt="<%= connectable.title %>" />
    <% end %>
<% end %>
```
