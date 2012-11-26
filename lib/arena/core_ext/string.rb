class String

  def constantize
    self.split("::").inject(Module) {|acc, val| acc.const_get(val)}
  end unless method_defined?(:constantize)

end