module ChefSpec
  # Supports running minitest-chef-handler examples without a real converge.
  #
  # This is experimental and comes with the following caveats:
  #
  # * This support is intended only to run existing examples at present. This
  #   means that it has not been tested with examples that explicitly create a
  #   new ChefRunner.
  # * Examples that shell out or access the file system using Ruby will fail.
  #   This support only ensures that minitest-chef-handler matchers work.
  # * Only a subset of minitest-chef-handler matchers are currently supported
  #   , equivalent to the built-in RSpec matchers.
  # * It is assumed that your spec class includes the `MiniTest::Chef` modules
  #   directly. Add this include for ChefSpec mode:
  #
  #       include ChefSpec::MiniTest
  module MiniTest

    # minitest-chef-handler declares methods for each resource that use
    # `load_current_resource` to fetch the current state of the node. We override
    # these and instantiate fresh resources.
    def self.override_minitest_resources(run_context, within_module)
      ::Chef::Resource.constants.each do |resource|
        if Chef::Resource.const_get(resource).respond_to?(:ancestors) and
          Chef::Resource.const_get(resource).ancestors.include? Chef::Resource
            method_name = Chef::Mixin::ConvertToClassName.
              convert_to_snake_case(resource.to_s).to_sym
            within_module.send(:define_method, method_name) do |name|
              Chef::Resource.const_get(resource).new(name).tap do |r|
                r.run_context = run_context
              end
            end
        end
      end
    end

    # minitest-chef-handler patches `Chef::Resource` to handle file uid and gid
    # conversion. In our instance these values are not populated by the
    # provider and will instead be whatever was specified against the resource
    # so we remove this conversion.
    def self.remove_file_id_conversion
      ::Chef::Resource.class_eval do
        def resource_value(attribute)
          send(attribute)
        end
      end
    end

    def self.override_minitest_assertions(chef_run)

      remove_file_id_conversion

      ::MiniTest::Chef::Assertions.class_eval do

        def assert_includes_content(file, content)
          assert file_includes_content?(file, content),
            "Expected file '#{file.path}' to include the specified content"
          file
        end

        def refute_includes_content(file, content)
          refute file_includes_content?(file, content),
            "Expected file '#{file.path}' not to include the specified content"
          file
        end

        def assert_path_exists(file_or_dir)
          paths = file_resources + resources_by_type(:directory)
          actual_resource = paths.find{|file| file_or_dir.path == file.path and
            ! Array(file.action).include?(:delete)}
          assert actual_resource, "Expected path '#{file_or_dir.path}' to exist"
          actual_resource
        end

        def refute_path_exists(file_or_dir)
          paths = file_resources + resources_by_type(:directory)
          actual_resource = paths.find{|file| file_or_dir.path == file.path and
            Array(file.action).include?(:delete)}
          assert actual_resource, "Expected path '#{file_or_dir.path}' not to exist"
          actual_resource
        end

        private

        def same_resource_type?(expected_resource, actual_resource)
          case actual_resource.resource_name.to_s
            when /file$/
              expected_resource.resource_name == :file
            else
              expected_resource.resource_name == actual_resource.resource_name
            end
        end

        def find_resource(expected_resource, field)
          resources.find do |actual_resource|
            same_resource_type?(expected_resource, actual_resource) and
              expected_resource.send(field) == actual_resource.send(field)
          end
        end

        def self.override_assertion(assert_name, field, wont_actions = [])
          [:assert, :refute].each do |prefix|
            define_method("#{prefix}_#{assert_name}") do |expected_resource|
              actual_resource = find_resource(expected_resource, field)
              is_wont = false
              if actual_resource
                is_wont = ! (Array(actual_resource.action) & wont_actions).empty?
              end
              # If we are refuting then the assertion is actually positive,
              # we are for example asserting that the package has the `:remove`
              # action.
              if prefix == :assert || is_wont
                assert actual_resource
              else
                refute actual_resource
              end
              actual_resource
            end
          end
        end

        override_assertion :installed, :package_name, [:remove, :purge]
        override_assertion :enabled, :enabled, [:disable]
        override_assertion :running, :running, [:stop]
        override_assertion :user_exists, :username, [:remove]

        def file_resources
          resources.select{|r| r.resource_name.to_s.end_with?('file')} +
            resources.select{|r| r.resource_name == :template}
        end

        def resources_by_type(type)
          resources.select{|r| r.resource_name == type}
        end

        def cookbook_file_content(file_resource)
          file = cookbook_files(file_resource.cookbook_name).find do |f|
            Pathname.new(f).basename.to_s == file_resource.path
          end
          File.read(file)
        end

        def cookbook_files(cookbook)
          run_context.cookbook_collection[cookbook].file_filenames
        end

        def file_includes_content?(file, content)
          file_resources.any? do |f|
            f.path == file.path &&
              case f.resource_name
                when :cookbook_file
                  cookbook_file_content(f)
                when :file
                  f.content
                when :template
                  render(f, node)
                else raise NotImplementedError,
                  ":#{f.resource_name} not supported for comparison"
              end.include?(content)
          end
        end

      end
    end

    def self.share_object(spec_mod, name, obj)
      spec_mod.send(:define_method, name) do
        obj
      end
    end

    def self.included(other_mod)
      self.support_fake_converge(other_mod) if spec_module?(other_mod)
    end

    def self.support_fake_converge(spec_mod)
      chef_run = ChefSpec::ChefRunner.new(
        :cookbook_path => default_cookbook_path).converge recipe_for_module(spec_mod)
      override_minitest_resources(chef_run.run_context, spec_mod)
      override_minitest_assertions(chef_run)
      share_object(spec_mod, :node, chef_run.node)
      share_object(spec_mod, :resources, chef_run.resources)
      share_object(spec_mod, :run_context, chef_run.run_context)
    end

    def self.recipe_for_module(mod)
      mod.to_s.split('::')[-2..-1].join('::')
    end

    def self.spec_module?(mod)
      # minitest-chef-handler module names are of the form:
      # `recipe::example::default`
      recipe_for_module(mod) == recipe_for_module(mod).downcase
    end

    def self.default_cookbook_path
      Pathname.new(File.join(caller(3).first.split(':').slice(0..-3).first, "..", "..", "..")).cleanpath
    end
  end
end
