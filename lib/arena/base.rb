module Arena
  class Base
    attr_reader :attrs
    alias to_hash attrs

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @param attrs [Array, Set, Symbol]
    def self.attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            @attrs[attribute.to_s]
          end
        end
      end
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Arena::Base]
    def initialize(attrs={})
      @attrs = attrs
    end

    # Update the attributes of an object
    #
    # @param attrs [Hash]
    # @return [Arena::Base]
    # def update(attrs)
    #   @attrs.update(attrs)
    #   self
    # end

  protected

    # @param attr [Symbol]
    # @param other [Arena::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr).nil? && send(attr) == other.send(attr)
    end

    # @param other [Arena::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && attrs == other.attrs
    end

  end
end
