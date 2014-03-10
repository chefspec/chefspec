module ChefSpec
  class Coverage
    class Filter
      def initialize(filter)
        @filter = filter
      end

      def matches?
        raise RuntimeError, "Must override Filter#matches?"
      end
    end

    #
    # @example Match resources based on a regular expression.
    #   add_filter /^test/
    #
    class RegexpFilter < Filter
      def matches?(resource)
        @filter =~ resource.source_line
      end
    end

    #
    # @example Match resources based on a regular expression.
    #   add_filter 'test/bar/zip'
    #
    class StringFilter < RegexpFilter
      def initialize(filter)
        super(Regexp.new("^#{filter}"))
      end
    end

    #
    # @example Match resources based on a custom block.
    #   # Ignore internal cookbooks
    #   add_filter do |resource|
    #     resource.name =~ /^acme-(.+)/
    #   end
    #
    class BlockFilter < Filter
      def matches?(resource)
        @filter.call(resource)
      end
    end

    #
    # @example Ignore dependent cookbooks (via Berkshelf)
    #   add_filter BerkshelfFilter.new(berksfile)
    #
    class BerkshelfFilter < Filter
      def initialize(berksfile)
        @berksfile = berksfile

        @metadatas = if berksfile.respond_to?(:dependencies)
          berksfile.dependencies
            .select(&:metadata?)
            .map(&:name)
        else
          berksfile.sources.select(&:location)
            .map(&:location)
            .select(&:metadata?)
            .map(&:name)
        end
      end

      def matches?(resource)
        resource.source_line =~ /cookbooks\/(?!#{@metadatas.join('|')})/
      end
    end
  end
end
