module ChefSpec
  module Error
    class ChefSpecError < StandardError
      def initialize(options = {})
        class_name = self.class.to_s.split('::').last
        filename   = options.delete(:_template) || Util.underscore(class_name)
        template   = ChefSpec.root.join('templates', 'errors', "#{filename}.erb")

        erb = Erubis::Eruby.new(File.read(template))
        super erb.evaluate(options)
      end
    end

    class NotStubbed < ChefSpecError
      def initialize(options = {})
        name  = self.class.name.to_s.split('::').last
        type  = Util.underscore(name).gsub('_not_stubbed', '')
        klass = Stubs.const_get(name.gsub('NotStubbed', '') + 'Stub')
        stub  = klass.new(*options[:args]).and_return('...').signature

        signature = "#{type}(#{options[:args].map(&:inspect).join(', ')})"

        super({
          type:      type,
          signature: signature,
          stub:      stub,
          _template: :not_stubbed,
        }.merge(options))
      end
    end

    class CommandNotStubbed < NotStubbed; end
    class SearchNotStubbed < NotStubbed; end
    class DataBagNotStubbed < NotStubbed; end
    class DataBagItemNotStubbed < NotStubbed; end
    class ShellOutNotStubbed < ChefSpecError; end

    class CookbookPathNotFound < ChefSpecError; end
    class GemLoadError < ChefSpecError; end

    class MayNeedToSpecifyPlatform < ChefSpecError; end

    class InvalidBerkshelfOptions < ChefSpecError; end

    class TemplateNotFound < ChefSpecError; end
    class ErbTemplateParseError < ChefSpecError; end
  end
end
