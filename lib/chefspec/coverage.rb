module ChefSpec
  class Coverage
    class << self
      extend Forwardable
      def_delegators :instance, :add, :cover!, :report!
    end

    include Singleton

    #
    # Create a new coverage object singleton.
    #
    def initialize
      @collection = {}
    end

    #
    # Add a resource to the resource collection.
    #
    # @param [Chef::Resource] resource
    #
    def add(resource)
      @collection[resource.to_s] = ResourceWrapper.new(resource)
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
