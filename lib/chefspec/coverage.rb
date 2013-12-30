module ChefSpec
  class Coverage

    attr_accessor :filters

    class << self
      extend Forwardable
      def_delegators :instance, :add, :cover!, :report!, :filters
    end

    include Singleton

    #
    # Create a new coverage object singleton.
    #
    def initialize
      @collection = {}
      @filters = []
    end

    #
    # Add a resource to the resource collection. Only new resources are added
    # and only resources that match the given filter are covered (which is *
    # by default).
    #
    # @param [Chef::Resource] resource
    #
    def add(resource)
      if !exists?(resource) && filtered?(resource)
        @collection[resource.to_s] = ResourceWrapper.new(resource)
      end
    end

    #
    # Called when a resource is matched to indicate it has been tested.
    #
    # @param [Chef::Resource] resource
    #
    def cover!(resource)
      if filtered?(resource) && (wrapper = find(resource))
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
      filters.empty? || filters.any? { |f| resource.source_line =~/^#{f}/ }
    end

    #
    # Generate a coverage report. This report **must** be generated +at_exit+
    # or else the entire resource collection may not be complete!
    #
    # @example Generating a report
    #
    #   at_exit { ChefSpec::Coverage.report! }
    #
    # @example Generating a custom report without announcing
    #
    #   at_exit { ChefSpec::Coverage.report!('/custom/path', false) }
    #
    #
    # @param [String] output
    #   the path to output the report on disk (default: '.coverage/results.json')
    # @param [Boolean] announce
    #   print the results to standard out
    #
    def report!(output = '.coverage/results.json', announce = true)
      report = {}

      report[:total] = @collection.size
      report[:touched] = @collection.count { |_, resource| resource.touched? }
      report[:untouched] = report[:total] - report[:touched]
      report[:coverage] = ((report[:touched].to_f/report[:total].to_f)*100).round(2)

      report[:detailed] = Hash[*@collection.map do |name, wrapper|
        [name, wrapper.to_hash]
      end.flatten]

      output = File.expand_path(output)
      FileUtils.mkdir_p(File.dirname(output))
      File.open(File.join(output), 'w') do |f|
        f.write(JSON.pretty_generate(report) + "\n")
      end

      if announce
        puts <<-EOH.gsub(/^ {10}/, '')

          WARNING: ChefSpec Coverage reporting is in beta. Please use with caution.

          ChefSpec Coverage report generated at '#{output}':

            Total Resources:   #{report[:total]}
            Touched Resources: #{report[:touched]}
            Touch Coverage:    #{report[:coverage]}%

          Untouched Resources:

          #{
            report[:detailed]
              .select { |_, resource| !resource[:touched] }
              .sort_by { |_, resource| [resource[:source][:file], resource[:source][:line]] }
              .map do |name, resource|
                "  #{name} #{resource[:source][:file]}:#{resource[:source][:line]}"
              end
              .flatten
              .join("\n")
          }

        EOH
      end
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

        def source
          return {} unless @resource.source_line
          file, line, *_ = @resource.source_line.split(':')

          {
            file: file,
            line: line.to_i,
          }
        end

        def to_hash
          {
            source: source,
            touched: touched?,
          }
        end

        def touch!
          @touched = true
        end

        def touched?
          !!@touched
        end
      end
  end
end
