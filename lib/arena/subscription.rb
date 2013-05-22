require "arena/base"

module Arena
  class Subscription < Arena::Base
    include Arena::Creatable

    attr_reader :id, :callback_url, :subscribable_type, :subscribable_id, :trigger, :challenge
  end # Subscription
end # Arena
