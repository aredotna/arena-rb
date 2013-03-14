require "arena/error"

module Arena
  class Error
    # Raised when Cache engine is unavailable
    # 
    class CacheError < Arena::Error
    end
  end
end
