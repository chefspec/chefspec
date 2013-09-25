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
      warn "[DEPRECATION] #{message} (called from #{calling_spec})"
    end
  end
end

module ChefSpec
  class ChefRunner
    def self.new(*args, &block)
      deprecated '`ChefSpec::ChefRunner` is deprecated. Please use' \
        ' `ChefSpec::Runner` instead.'

      ChefSpec::Runner.new(*args, &block)
    end
  end
end

module ChefSpec
  class Runner
    alias_method :existing_initialize, :initialize
    def initialize(*args, &block)
      if args.first.is_a?(Hash)
        if args.first.has_key?(:evaluate_guards)
          deprecated 'The `:evaluate_guards` option is deprecated. Guards are' \
            ' automatically evaluated by default. Please use `stub_command` to' \
            ' stub shell guards.'
        end

        if args.first.has_key?(:actually_run_shell_guards)
          deprecated 'The `:actually_run_shell_guards` option is deprecated.' \
            ' Shell commands must be stubbed using `stub_command`.'
        end
      end

      existing_initialize(*args, &block)
    end
  end
end
