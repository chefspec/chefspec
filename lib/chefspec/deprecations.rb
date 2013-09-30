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
  # @deprecated {ChefSpec::ChefRunner} is deprecated. Please use
  #   {ChefSpec::Runner} instead.
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

module ChefSpec
  module API
    module DeprecatedMatchers
      def be_owned_by(user, group)
        deprecated "The `be_owned_by` matcher is deprecated. Please use:" \
          "\n\n" \
          "  expect(resource.owner).to eq('#{user}')\n" \
          "  expect(resource.group).to eq('#{group}')" \
          "\n\n" \
          "instead"
        raise ChefSpec::NoConversionError
      end

      def create_file_with_content(path, content)
        deprecated "The `create_file_with_content` matcher is deprecated." \
          " Please use `render_file(#{path.inspect})" \
          ".with_content(#{content.inspect})` instead."
        ChefSpec::Matchers::RenderFileMatcher.new(path).with_content(content)
      end

      [:package, :yum_package, :gem_package, :chef_gem].each do |type|
        matcher_name = "install_#{type}_at_version".to_sym
        define_method(matcher_name) do |name, version|
          deprecated "The `#{matcher_name}` matcher is deprecated." \
            " Please use `install_package(#{name.inspect})" \
            ".with(version: #{version.inspect})` instead."
          ChefSpec::Matchers::ResourceMatcher.new(type, :install, package)
            .with(version: version)
        end
      end

      [:bash, :csh, :perl, :python, :ruby, :script].each do |type|
        matcher_name = "execute_#{type}_script".to_sym
        define_method(matcher_name) do |name|
          deprecated "The `#{matcher_name}` matcher is deprecated." \
            " Please use `run_#{type}(#{name.inspect})` instead."
          ChefSpec::Matchers::ResourceMatcher.new(type, :run, name)
        end
      end

      def log(message)
        deprecated "The `log` matcher is deprcated. Please use" \
          " `write_log(#{message.inspect}) instead."
        ChefSpec::Matchers::ResourceMatcher.new(:log, :write, message)
      end

      def set_service_to_start_on_boot(service)
        deprecated "The `set_service_to_start_on_boot` matcher is" \
          " deprecated. Please use `enable_service(#{service.inspect})`" \
          " instead."
        ChefSpec::Matchers::ResourceMatcher.new(:service, :enable, service)
      end

      def set_service_to_not_start_on_boot(service)
        deprecated "The `set_service_to_not_start_on_boot` matcher is" \
          " deprecated. Please use `enable_service(#{service.inspect})`" \
          " with a negating argument instead."
        raise ChefSpec::NoConversionError
      end

      def execute_ruby_block(name)
        deprecated "The `execute_ruby_block` matcher is deprecated. Please" \
          " use `run_ruby_block(#{name.inspect})` instead."
        ChefSpec::Matchers::ResourceMatcher.new(:ruby_block, :run, name)
      end

      def execute_command(command)
        deprecated "The `execute_command` matcher is deprecated. Please" \
          " use `run_execute(#{command.inspect})` instead."
        ChefSpec::Matchers::ResourceMatcher.new(:execute, :run, command)
      end
    end
  end
end

module ChefSpec
  class NoConversionError < Error
    def initialize(matcher)
      message = "I cannot convert `#{matcher}` to use a new matcher format!" \
        " Please see the ChefSpec documentation and Changelog for details" \
        " on converting this matcher. Sorry :("

      super(message)
    end
  end
end
