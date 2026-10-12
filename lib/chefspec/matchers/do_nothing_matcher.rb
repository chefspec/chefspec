module ChefSpec::Matchers
  #
  # Asserts that a resource performed no actions during the Chef run.
  #
  # Built by {ChefSpec::API::DoNothing#do_nothing}. A resource matches when it
  # performed no actions at all, or only the +:nothing+ action.
  #
  # @example
  #   expect(chef_run.service("apache2")).to do_nothing
  #
  class DoNothingMatcher
    #
    # Determine whether the resource performed anything other than +:nothing+.
    #
    # Marks the resource as covered in the coverage report as a side effect.
    #
    # @param [Chef::Resource] resource
    #   the resource to inspect
    #
    # @return [true, false]
    #
    def matches?(resource)
      @resource = resource

      if @resource
        ChefSpec::Coverage.cover!(@resource)

        actions = @resource.performed_actions
        actions.empty? || actions == [:nothing]
      else
        false
      end
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      "do nothing"
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      if @resource
        message =  %{expected #{@resource} to do nothing, but the following }
        message << %{actions were performed:}
        message << %{\n\n}
        @resource.performed_actions.each do |action|
          message << %{  :#{action}}
        end
        message
      else
        message =  %{expected _something_ to do nothing, but the _something_ }
        message << %{you gave me was nil! If you are running a test like:}
        message << %{\n\n}
        message << %{  expect(_something_).to do_nothing}
        message << %{\n\n}
        message << %{make sure that `_something_` exists, because I got nil!}
        message
      end
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      if @resource
        message =  %{expected #{@resource} to do something, but no actions }
        message << %{were performed.}
        message
      else
        message =  %{expected _something_ to do something, but no actions }
        message << %{were performed.}
        message
      end
    end
  end
end
