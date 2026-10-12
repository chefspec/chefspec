module ChefSpec::Matchers
  #
  # Asserts that a resource declares an exact set of state attributes.
  #
  # Built by {ChefSpec::API::StateAttrs#have_state_attrs}. The comparison is
  # order-sensitive and exact, not a subset check.
  #
  # @example
  #   expect(chef_run.my_resource("thing")).to have_state_attrs(:owner, :mode)
  #
  class StateAttrsMatcher
    #
    # Create a new state_attrs matcher.
    #
    # @param [Array] state_attrs
    #
    def initialize(state_attrs)
      @expected_attrs = state_attrs.map(&:to_sym)
    end

    #
    # Determine whether the resource declares exactly the expected state
    # attributes.
    #
    # @param [Chef::Resource] resource
    #   the resource to inspect
    #
    # @return [true, false]
    #
    def matches?(resource)
      @resource = resource
      @resource && matches_state_attrs?
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      %Q{have state attributes #{@expected_attrs.inspect}}
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      if @resource
        "expected #{state_attrs.inspect} to equal #{@expected_attrs.inspect}"
      else
        "expected _something_ to have state attributes, but the " \
        "_something_ you gave me was nil!" \
        "\n" \
        "Ensure the resource exists before making assertions:" \
        "\n\n" \
        "  expect(resource).to be" \
        "\n "
      end
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      if @resource
        "expected #{state_attrs.inspect} to not equal " \
        "#{@expected_attrs.inspect}"
      else
        "expected _something_ to not have state attributes, but the " \
        "_something_ you gave me was nil!" \
        "\n" \
        "Ensure the resource exists before making assertions:" \
        "\n\n" \
        "  expect(resource).to be" \
        "\n "
      end
    end

    private

    #
    # Determine if all the expected state attributes are present on the
    # given resource.
    #
    # @return [true, false]
    #
    def matches_state_attrs?
      @expected_attrs == state_attrs
    end

    #
    # The list of state attributes declared on the given resource.
    #
    # @return [Array<Symbol>]
    #
    def state_attrs
      @resource.class.state_attrs.map(&:to_sym)
    end
  end
end
