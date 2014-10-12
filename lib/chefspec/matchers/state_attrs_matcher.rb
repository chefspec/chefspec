module ChefSpec::Matchers
  class StateAttrsMatcher
    #
    # Create a new state_attrs matcher.
    #
    # @param [Array] state_attrs
    #
    def initialize(state_attrs)
      @expected_attrs = state_attrs.map(&:to_sym)
    end

    def matches?(resource)
      @resource = resource
      @resource && matches_state_attrs?
    end

    def description
      %Q{have state attributes #{@expected_attrs.inspect}}
    end

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
