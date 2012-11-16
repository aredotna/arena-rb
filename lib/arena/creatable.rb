require 'time'

module Arena
  module Creatable

    # Time when the object was created on Arena
    #
    # @return [Time]
    def created_at
      @created_at ||= Time.parse(@attrs[:created_at]) if created?
    end

  private

    def created?
      !@attrs[:created_at].nil?
    end

  end
end
