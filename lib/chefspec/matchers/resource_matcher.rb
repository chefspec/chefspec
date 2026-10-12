require "rspec/expectations/fail_with"

module ChefSpec::Matchers
  #
  # Asserts that the Chef run declared a resource that performed an action.
  #
  # This backs the generated +action_resource+ matchers, so
  # +create_template("/etc/foo")+ builds a +ResourceMatcher+ for the +:create+
  # action on +template[/etc/foo]+. Chain {#with} to assert on properties, and
  # {#at_compile_time} or {#at_converge_time} to assert on the phase.
  #
  # @example
  #   expect(chef_run).to create_template("/etc/foo").with(owner: "root")
  #
  class ResourceMatcher
    #
    # Create a new matcher for a resource, action, and identity.
    #
    # @param [Symbol, String] resource_name
    #   the type of resource, such as +:template+
    #
    # @param [Symbol] expected_action
    #   the action the resource is expected to have performed
    #
    # @param [String, Regexp] expected_identity
    #   the name or identity attribute of the resource
    #
    def initialize(resource_name, expected_action, expected_identity)
      @resource_name     = resource_name
      @expected_action   = expected_action
      @expected_identity = expected_identity
    end

    #
    # Assert that the resource was declared with the given properties.
    #
    # May be chained more than once; the given properties are merged. Values are
    # compared with +===+, so regular expressions and RSpec matchers work as
    # well as literals.
    #
    # @example
    #   expect(chef_run).to create_template("/etc/foo").with(mode: "0644")
    #
    # @param [Hash] parameters
    #   the resource properties to assert on
    #
    # @return [self]
    #
    def with(parameters = {})
      params.merge!(parameters)
      self
    end

    #
    # Assert that the resource performed its action at compile time.
    #
    # @raise [ArgumentError]
    #   if {#at_converge_time} was already chained
    #
    # @return [self]
    #
    def at_compile_time
      raise ArgumentError, "Cannot specify both .at_converge_time and .at_compile_time!" if @converge_time

      @compile_time = true
      self
    end

    #
    # Assert that the resource performed its action at converge time.
    #
    # @raise [ArgumentError]
    #   if {#at_compile_time} was already chained
    #
    # @return [self]
    #
    def at_converge_time
      raise ArgumentError, "Cannot specify both .at_compile_time and .at_converge_time!" if @compile_time

      @converge_time = true
      self
    end

    #
    # Allow users to specify fancy #with matchers.
    #
    def method_missing(m, *args, &block)
      if m.to_s =~ /^with_(.+)$/
        with($1.to_sym => args.first)
        self
      else
        super
      end
    end

    def respond_to_missing?(m, include_private = false)
      m.to_s.match?(/^with_(.+)$/) || super
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      %Q{#{@expected_action} #{@resource_name} "#{@expected_identity}"}
    end

    #
    # Determine whether a matching resource performed the expected action with
    # the expected properties, in the expected phase.
    #
    # Marks the resource as covered in the coverage report as a side effect.
    #
    # @param [ChefSpec::SoloRunner, ChefSpec::ServerRunner] runner
    #   the converged runner to inspect
    #
    # @return [true, false, nil]
    #
    def matches?(runner)
      @runner = runner

      if resource
        ChefSpec::Coverage.cover!(resource)
        unmatched_parameters.empty? && correct_phase?
      end
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # Falls back to describing similar resources in the run when no resource
    # matched at all, which usually points at a typo or a missing platform.
    #
    # @return [String]
    #
    def failure_message
      if resource
        if unmatched_parameters.empty?
          if @compile_time
            %Q{expected "#{resource}" to be run at compile time}
          else
            %Q{expected "#{resource}" to be run at converge time}
          end
        else
          message = %Q{expected "#{resource}" to have parameters:} \
            "\n\n" \
            "  " + unmatched_parameters.collect { |parameter, h|
              msg = "#{parameter} #{h[:expected].inspect}, was #{h[:actual].inspect}"
              diff = diff_for(h[:expected], h[:actual], message)
              msg += diff if diff
              msg
            }.join("\n  ")
        end
      else
        %Q{expected "#{@resource_name}[#{@expected_identity}]"} \
          " with action :#{@expected_action} to be in Chef run." \
          " Other #{@resource_name} resources:" \
          "\n\n" \
          "  " + similar_resources.join("\n  ") + "\n "
      end
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      if resource
        message = %Q{expected "#{resource}" actions #{resource.performed_actions.inspect} to not exist}
      else
        message = %Q{expected "#{resource}" to not exist}
      end

      message << " at compile time"  if @compile_time
      message << " at converge time" if @converge_time
      message
    end

    private

    #
    # Build the diff text for a mismatched parameter using rspec-expectations'
    # private diff helper. That helper was renamed and its signature changed in
    # rspec-expectations 3.12.4 (`ExpectedsForMultipleDiffs.from(expected)` with
    # `message_with_diff(message, differ, actual)` became
    # `MultiMatcherDiff.from(expected, actual)` with
    # `message_with_diff(message, differ)`), so support both shapes.
    #
    # @return [String, nil]
    #
    def diff_for(expected, actual, message)
      differ = ::RSpec::Expectations.differ
      if defined?(::RSpec::Matchers::MultiMatcherDiff)
        ::RSpec::Matchers::MultiMatcherDiff.from(expected, actual)
          .message_with_diff(message, differ)
      else
        ::RSpec::Matchers::ExpectedsForMultipleDiffs.from(expected)
          .message_with_diff(message, differ, actual)
      end
    end

    def unmatched_parameters
      return @_unmatched_parameters if @_unmatched_parameters

      @_unmatched_parameters = {}

      params.each do |parameter, expected|
        unless matches_parameter?(parameter, expected)
          @_unmatched_parameters[parameter] = {
            expected: expected,
            actual: safe_send(parameter),
          }
        end
      end

      @_unmatched_parameters
    end

    def matches_parameter?(parameter, expected)
      value = safe_send(parameter)
      if parameter == :source
        # Chef may store the source parameter internally as an Array. Match the
        # expectation against the value directly first, so RSpec matchers and
        # Regexps work against a scalar source, then fall back to comparing the
        # array-normalized forms so a plain string still matches a single-element
        # array source.
        expected === value || Array(expected) == Array(value)
      elsif expected.is_a?(Class)
        # Ruby can't compare classes with ===
        expected == value
      else
        expected === value
      end
    end

    def correct_phase?
      if @compile_time
        resource.performed_action(@expected_action)[:compile_time]
      elsif @converge_time
        resource.performed_action(@expected_action)[:converge_time]
      else
        true
      end
    end

    def safe_send(parameter)
      resource.send(parameter)
    rescue NoMethodError
      nil
    end

    #
    # Any other resources in the Chef run that have the same resource
    # type. Used by {failure_message} to be ultra helpful.
    #
    # @return [Array<Chef::Resource>]
    #
    def similar_resources
      @_similar_resources ||= @runner.find_resources(@resource_name)
    end

    #
    # Find the resource in the Chef run by the given class name and
    # resource identity/name.
    #
    # @see ChefSpec::SoloRunner#find_resource
    #
    # @return [Chef::Resource, nil]
    #
    def resource
      @_resource ||= @runner.find_resource(@resource_name, @expected_identity, @expected_action)
    end

    #
    # The list of parameters passed to the {with} matcher.
    #
    # @return [Hash]
    #
    def params
      @_params ||= {}
    end
  end
end
