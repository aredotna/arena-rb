module Arena
  class Summary
    attr_reader :indicative, :kinds, :size

    def initialize(stories)
      @indicative = stories.first
      @kinds      = stories.collect { |story| story.item._class }.uniq
      @size       = stories.size
    end
  end # Summary
end # Arena
