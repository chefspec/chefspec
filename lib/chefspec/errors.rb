module ChefSpec
  module Error
    class ChefSpecError < StandardError
      def initialize(options = {})
        class_name = self.class.to_s.split('::').last
        error_key  = options[:_error_key] || Util.underscore(class_name)

        super I18n.t("chefspec.errors.#{error_key}", options)
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
          type:       type,
          signature:  signature,
          stub:       stub,
          _error_key: :not_stubbed,
        }.merge(options))
      end
    end

    class CommandNotStubbed < NotStubbed; end
    class SearchNotStubbed < NotStubbed; end
    class DataBagNotStubbed < NotStubbed; end
    class DataBagItemNotStubbed < NotStubbed; end

    class CookbookPathNotFound < ChefSpecError; end
    class GemLoadError < ChefSpecError; end
  end
end
