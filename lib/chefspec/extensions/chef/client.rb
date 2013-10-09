require 'chef/client'

# @private
class Chef::Client
  attr_reader :events

  #
  # Don't actually run ohai (we have fake data for that)
  #
  # @see Chef::Client#run_ohai
  #
  def run_ohai
    # noop
  end
end
