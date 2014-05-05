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
      @should_report_untested_recipes = false
    end

    #
    # Start the coverage reporting analysis. This method also adds the the
    # +at_exit+ handler for printing the coverage report.
    #
    def start!(&block)
      instance_eval(&block) if block
      at_exit { ChefSpec::Coverage.report! }
    end

    #
    # Add a filter to the converage analysis.
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
    # Enable/Disable showing untested recipes in the coverage report
    #
    # @param [Bool] switch
    #   should the coverage report show untested recipes?
    #
    def report_untouched_recipes(switch = true)
      @should_report_untested_recipes = switch
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
        h[:resource_total]     = @collection.size
        h[:resource_touched]   = @collection.count { |_, resource| resource.touched? }
        h[:resource_coverage]  = ((h[:resource_touched]/h[:resource_total].to_f)*100).round(2)
        h[:recipe_reported]    = @should_report_untested_recipes
      end

      report[:resource_untouched] = @collection.collect do |_, resource|
        resource unless resource.touched?
      end.compact

      if @should_report_untested_recipes
        all_recipes = []
        Chef::Config.cookbook_path.each do |path|
          all_recipes += Dir[path + "/*/recipes/*.rb"]
        end

        all_recipes.map! do |recipe|
          "/" + recipe
        end

        report[:recipe_untouched] = all_recipes.select do |recipe|
          recipe unless @collection.find do |_, resource|
            resource.source_file == recipe
          end
        end

        report[:recipe_total] = all_recipes.size
        report[:recipe_touched] = report[:recipe_total] - report[:recipe_untouched].size
        report[:recipe_coverage] = ((report[:recipe_touched]/report[:recipe_total].to_f)*100).round(2)
        report[:full_coverage] = report[:recipe_untouched].empty? and report[:resource_untouched].empty?
        report[:has_results] = report[:recipe_total] or report[:resource_total]
      else
        report[:full_covarege] = report[:resource_untouched].empty?
        report[:has_results] = report[:resource_total]
      end



      template = ChefSpec.root.join('templates', 'coverage', 'human.erb')
      erb = Erubis::Eruby.new(File.read(template))
      puts erb.evaluate(report)

      # Ensure we exit correctly (#351)
      exit(exit_status)
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
