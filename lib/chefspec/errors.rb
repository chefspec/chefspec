module ChefSpec
  #
  # Namespace for all ChefSpec exceptions.
  #
  # Every error in this namespace renders its message from an ERB template in
  # +templates/errors+. The template is chosen by underscoring the class name,
  # so {CookbookPathNotFound} renders +cookbook_path_not_found.erb+. This keeps
  # long, user-facing explanations out of the Ruby source.
  #
  module Error
    #
    # The base class for all ChefSpec errors.
    #
    # Subclasses do not usually define a message. Instead they rely on this
    # constructor to locate the matching ERB template and evaluate it with the
    # options passed in.
    #
    # @example Defining an error backed by +templates/errors/my_error.erb+
    #   class MyError < ChefSpecError; end
    #   raise MyError.new(name: "thing")
    #
    class ChefSpecError < StandardError
      #
      # Create a new error, rendering its message from an ERB template.
      #
      # @param [Hash] options
      #   the local variables to expose to the ERB template
      #
      # @option options [String, Symbol] :_template
      #   the template basename to render, overriding the underscored class
      #   name that would otherwise be used
      #
      def initialize(options = {})
        class_name = self.class.to_s.split("::").last
        filename   = options.delete(:_template) || Util.underscore(class_name)
        template   = ChefSpec.root.join("templates", "errors", "#{filename}.erb")

        erb = Erubis::Eruby.new(File.read(template))
        super erb.evaluate(options)
      end
    end

    #
    # Raised when a cookbook calls out to the real world instead of a stub.
    #
    # All subclasses share the +not_stubbed.erb+ template, which prints the
    # unstubbed call alongside a copy-pasteable stub that would satisfy it. The
    # subclass name drives both the human-readable type and the {Stubs} class
    # used to build that example, so +SearchNotStubbed+ resolves to
    # +ChefSpec::Stubs::SearchStub+.
    #
    class NotStubbed < ChefSpecError
      #
      # Create a new error describing the call that was not stubbed.
      #
      # @param [Hash] options
      #   the options passed through to the ERB template
      #
      # @option options [Array] :args
      #   the arguments the cookbook used, replayed to build the suggested stub
      #
      def initialize(options = {})
        name  = self.class.name.to_s.split("::").last
        type  = Util.underscore(name).gsub("_not_stubbed", "")
        klass = Stubs.const_get(name.gsub("NotStubbed", "") + "Stub")
        stub  = klass.new(*options[:args]).and_return("...").signature

        signature = "#{type}(#{options[:args].map(&:inspect).join(", ")})"

        super({
          type: type,
          signature: signature,
          stub: stub,
          _template: :not_stubbed,
        }.merge(options))
      end
    end

    # Raised when a cookbook shells out to a command that was not stubbed.
    class CommandNotStubbed < NotStubbed; end

    # Raised when a cookbook performs a search that was not stubbed.
    class SearchNotStubbed < NotStubbed; end

    # Raised when a cookbook loads a data bag that was not stubbed.
    class DataBagNotStubbed < NotStubbed; end

    # Raised when a cookbook loads a data bag item that was not stubbed.
    class DataBagItemNotStubbed < NotStubbed; end

    # Raised when a resource calls +shell_out+ without a matching stub.
    class ShellOutNotStubbed < ChefSpecError; end

    # Raised when +Chef::Mixin::ShellOut+ is used without a matching stub.
    class MixinShellOutNotStubbed < ChefSpecError; end

    # Raised when the cookbook path could not be found or inferred.
    class CookbookPathNotFound < ChefSpecError; end

    # Raised when an optional integration gem, such as Berkshelf, is missing.
    class GemLoadError < ChefSpecError; end

    #
    # Raised when a resource could not be found, which usually means the
    # example did not specify the platform the resource is available on.
    #
    class MayNeedToSpecifyPlatform < ChefSpecError; end

    # Raised when +berkshelf_options+ is not a hash with symbol keys.
    class InvalidBerkshelfOptions < ChefSpecError; end

    # Raised when the configured coverage report template cannot be found.
    class TemplateNotFound < ChefSpecError; end

    # Raised when an ERB template could not be parsed while rendering.
    class ErbTemplateParseError < ChefSpecError; end
  end
end
