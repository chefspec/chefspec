module ChefSpec::Matchers
  class DoNothingMatcher
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

    def description
      'do nothing'
    end

    def failure_message
      if @resource
        message =  %|expected #{@resource} to do nothing, but the following |
        message << %|actions were performed:|
        message << %|\n\n|
        @resource.performed_actions.each do |action|
          message << %|  :#{action}|
        end
        message
      else
        message =  %|expected _something_ to do nothing, but the _something_ |
        message << %|you gave me was nil! If you are running a test like:|
        message << %|\n\n|
        message << %|  expect(_something_).to do_nothing|
        message << %|\n\n|
        message << %|make sure that `_something_` exists, because I got nil!|
        message
      end
    end

    def failure_message_when_negated
      if @resource
        message =  %|expected #{@resource} to do something, but no actions |
        message << %|were performed.|
        message
      else
        message =  %|expected _something_ to do something, but no actions |
        message << %|were performed.|
        message
      end
    end
  end
end
