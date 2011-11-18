# Ruby stdlib Hash class
class Hash

  # Monkey-patch to stdlib Hash to give us Mash style lookup
  # @param [Symbol] method_id The method name
  def method_missing(method_id, *)
    key = method_id.id2name
    if has_key?(key)
      self[key]
    elsif has_key?(key.to_sym)
      self[key.to_sym]
    else
      super
    end
  end
end
