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
      if calling_spec
        calling_spec = 'spec/' + calling_spec.split('/spec/').last
        warn "[DEPRECATION] #{message} (called from #{calling_spec})"
      else
        warn "[DEPRECATION] #{message}"
      end
    end
  end
end

module ChefSpec
  class SoloRunner
    # @deprecated {ChefSpec::Runner.define_runner_method} is deprecated. Please
    #   use {ChefSpec.define_matcher} instead.
    def self.define_runner_method(resource_name)
      deprecated "`ChefSpec::Runner.define_runner_method' is deprecated." \
        " It is being used in the #{resource_name} resource matcher." \
        " Please use `ChefSpec.define_matcher' instead."

      ChefSpec.define_matcher(resource_name)
    end
  end

  class Server
    def self.method_missing(m, *args, &block)
      deprecated "`ChefSpec::Server.#{m}' is deprecated. There is no longer" \
        " a global Chef Server instance. Please use a ChefSpec::SoloRunner" \
        " instead. More documentation can be found in the ChefSpec README."
      raise ChefSpec::Error::NoConversionError
    end
  end
end

module ChefSpec::Error
  class NoConversionError < ChefSpecError;  end
end
