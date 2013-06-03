class Chef
  class Resource
    class Conditional
      alias_method :original_evaluate_command, :evaluate_command
      def evaluate_command
        runner.stubbed_commands.each do |stubbed_cmd, result|
          case command
            when stubbed_cmd then return result
          end
        end
        if runner.actually_run_shell_guards?
          return original_evaluate_command
        end
        raise RSpec::Mocks::MockExpectationError.new(
          "The following shell guard was unstubbed: #{description}")
      end
    end
  end
end
