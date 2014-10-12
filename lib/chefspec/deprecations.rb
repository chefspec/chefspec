module Kernel
  # Kernel extension to print deprecation notices.
  #
  # @example printing a deprecation warning
  #   deprecated 'no longer in use' #=> "[DEPRECATION] no longer in use"
  #
  # @param [Array<String>] messages
  def deprecated(*messages)
    messages.each do |message|
      calling_spec = caller.find { |line| line =~ /(\/spec)|(_spec\.rb)/ }
      calling_spec = 'spec/' + calling_spec.split('/spec/').last
      warn "[DEPRECATION] #{message} (called from #{calling_spec})"
    end
  end
end

module ChefSpec
  class Runner
    # @deprecated {ChefSpec.define_runner_method} is deprecated. Please
    #   use {ChefSpec.define_runner_method} instead.
    def self.define_runner_method(resource_name)
      deprecated "`ChefSpec.define_runner_method' is deprecated. " \
        "Please use `ChefSpec.define_runner_method' instead."

      ChefSpec.define_matcher(resource_name)
    end

    # @deprecated {ChefSpec::Runner.new} is deprecated. Please use
    #   {ChefSpec::SoloRunner} or {ChefSpec::ServerRunner} instead.
    def self.new(*args, &block)
      deprecated "`ChefSpec::Runner' is deprecated. Please use" \
        " `ChefSpec::SoloRunner' or `ChefSpec::ServerRunner' instead."

      ChefSpec::SoloRuner.new(*args, &block)
    end
  end
end

module ChefSpec::Error
  class NoConversionError < ChefSpecError
    def initialize(matcher)
      super "I cannot convert `#{matcher}` to use a new matcher format!" \
        " Please see the ChefSpec documentation and CHANGELOG for details" \
        " on converting this matcher. Sorry :("
    end
  end
end
