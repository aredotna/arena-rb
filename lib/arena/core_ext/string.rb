# frozen_string_literal: true

class String
  unless method_defined?(:constantize)
    def constantize
      split('::').inject(Module) { |acc, val| acc.const_get(val) }
    end
  end
end
