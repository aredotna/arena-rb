![Build Status](https://api.travis-ci.org/aredotna/arena-rb.svg?branch=master)

# Arena

## Installation

Add this line to your application's Gemfile:

    gem 'arena'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arena

## Usage

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
