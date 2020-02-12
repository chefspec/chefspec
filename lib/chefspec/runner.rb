require_relative "solo_runner"

module ChefSpec
  # As we start to migrate back to only SoloRunner, include this alias for now.
  #
  # @since 7.3
  Runner = SoloRunner
end
