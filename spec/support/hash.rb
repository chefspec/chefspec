#
# An extension of a Hash that allows mash-style like lookups.
#
# @private
#
class Hash
  # Like, seriously Windows?
  undef_method(:timeout)

  #
  # Monkey-patch to allow mash-style look ups for tests
  #
  def method_missing(m, *args, &block)
    if has_key?(m.to_sym)
      self[m.to_sym]
    elsif has_key?(m.to_s)
      self[m.to_s]
    else
      super
    end
  end

  #
  # Monkey-patch to stdlib Hash to correspond to Mash-style lookup
  #
  # @see Hash#respond_to?
  #
  def respond_to?(m, include_private = false)
    if has_key?(m.to_sym) || has_key?(m.to_s)
      true
    else
      super
    end
  end
end
