require_relative 'coverage/filters'

module ChefSpec
  class Coverage
    EXIT_FAILURE = 1
    EXIT_SUCCESS = 0

    class << self
      def method_added(name)
        # Only delegate public methods
        if method_defined?(name)
          instance_eval <<-EOH, __FILE__, __LINE__ + 1
            def #{name}(*args, &block)
              instance.public_send(:#{name}, *args, &block)
            end
          EOH
        end
      end
    end

    include Singleton

    attr_reader :filters

    #
    # Create a new coverage object singleton.
    #
    def initialize
      @collection = {}
      @filters    = {}
      @outputs    = []
      add_output do |report|
        begin
          erb = Erubis::Eruby.new(File.read(@template))
          puts erb.evaluate(report)
        rescue NameError => e
          raise Error::ErbTemplateParseError.new(original_error: e.message)
        end
      end
      @template = ChefSpec.root.join('templates', 'coverage', 'human.erb')
    end

    #
    # Start the coverage reporting analysis. This method also adds the the
    # +at_exit+ handler for printing the coverage report.
    #
    def start!(&block)
      warn("ChefSpec's coverage reporting is deprecated and will be removed in a future version")
      instance_eval(&block) if block
      at_exit { ChefSpec::Coverage.report! }
    end

    #
    # Add a filter to the coverage analysis.
    #
    # @param [Filter, String, Regexp] filter
    #   the filter to add
    # @param [Proc] block
    #   the block to use as a filter
    #
    # @return [true]
    #
    def add_filter(filter = nil, &block)
      id = "#{filter.inspect}/#{block.inspect}".hash

      @filters[id] = if filter.kind_of?(Filter)
                       filter
                     elsif filter.kind_of?(String)
                       StringFilter.new(filter)
                     elsif filter.kind_of?(Regexp)
                       RegexpFilter.new(filter)
                     elsif block
                       BlockFilter.new(block)
                     else
                       raise ArgumentError, 'Please specify either a string, ' \
                         'filter, or block to filter source files with!'
                     end

      true
    end

    #
    # Add an output to send the coverage results to.
    # @param [Proc] block
    #   the block to use as the output
    #
    # @return [true]
    #
    def add_output(&block)
      @outputs << block
    end

    #
    # Change the template for reporting of converage analysis.
    #
    # @param [string] path
    #   The template file to use for the output of the report
    #
    # @return [true]
    #
    def set_template(file = 'human.erb')
      [
        ChefSpec.root.join('templates', 'coverage', file),
        File.expand_path(file, Dir.pwd)
      ].each do |temp|
        if File.exist?(temp)
          @template = temp
          return
        end
      end
      raise Error::TemplateNotFound.new(path: file)
    end
    #
    # Add a resource to the resource collection. Only new resources are added
    # and only resources that match the given filter are covered (which is *
    # by default).
    #
    # @param [Chef::Resource] resource
    #
    def add(resource)
      if !exists?(resource) && !filtered?(resource)
        @collection[resource.to_s] = ResourceWrapper.new(resource)
      end
    end

    #
    # Called when a resource is matched to indicate it has been tested.
    #
    # @param [Chef::Resource] resource
    #
    def cover!(resource)
      if wrapper = find(resource)
        wrapper.touch!
      end
    end

    #
    # Called to check if a resource belongs to a cookbook from the specified
    # directories.
    #
    # @param [Chef::Resource] resource
    #
    def filtered?(resource)
      filters.any? { |_, filter| filter.matches?(resource) }
    end

    #
    # Generate a coverage report. This report **must** be generated +at_exit+
    # or else the entire resource collection may not be complete!
    #
    # @example Generating a report
    #
    #   ChefSpec::Coverage.report!
    #
    def report!
      # Borrowed from simplecov#41
      #
      # If an exception is thrown that isn't a "SystemExit", we need to capture
      # that error and re-raise.
      if $!
        exit_status = $!.is_a?(SystemExit) ? $!.status : EXIT_FAILURE
      else
        exit_status = EXIT_SUCCESS
      end

      report = {}.tap do |h|
        h[:total]     = @collection.size
        h[:touched]   = @collection.count { |_, resource| resource.touched? }
        h[:coverage]  = ((h[:touched]/h[:total].to_f)*100).round(2)
      end

      report[:untouched_resources] = @collection.collect do |_, resource|
        resource unless resource.touched?
      end.compact
      report[:all_resources] = @collection.values

      @outputs.each do |block|
        self.instance_exec(report, &block)
      end

      # Ensure we exit correctly (#351)
      Kernel.exit(exit_status) if exit_status && exit_status > 0
    end

    private

    def find(resource)
      @collection[resource.to_s]
    end

    def exists?(resource)
      !find(resource).nil?
    end

    class ResourceWrapper
      attr_reader :resource

      def initialize(resource = nil)
        @resource = resource
      end

      def to_s
        @resource.to_s
      end

      def to_json
        {
          "source_file" => source_file,
          "source_line" => source_line,
          "touched" => touched?,
          "resource" => to_s
        }.to_json
      end

      def source_file
        @source_file ||= if @resource.source_line
          shortname(@resource.source_line.split(':').first)
        else
          'Unknown'
        end
      end

      def source_line
        @source_line ||= if @resource.source_line
          @resource.source_line.split(':', 2).last.to_i
        else
          'Unknown'
        end
      end

      def touch!
        @touched = true
      end

      def touched?
        !!@touched
      end

      private

      def shortname(file)
        if file.include?(Dir.pwd)
          file.split(Dir.pwd, 2).last
        elsif file.include?('cookbooks')
          file.split('cookbooks/', 2).last
        else
          file
        end
      end
    end
  end
end
