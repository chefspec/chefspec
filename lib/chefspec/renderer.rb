begin
  require 'chef/mixin/template'
  require 'chef/provider/template_finder'
rescue LoadError
end

module ChefSpec
  class Renderer
    include ChefSpec::Normalize

    # @return [Chef::Runner]
    attr_reader :chef_run

    # @return [Chef::Resource]
    attr_reader :resource

    #
    # Create a new Renderer for the given Chef run and resource.
    #
    # @param [Chef::Runner] chef_run
    #   the Chef run containing the resources
    # @param [Chef::Resource] resource
    #   the resource to render content from
    #
    def initialize(chef_run, resource)
      @chef_run = chef_run
      @resource = resource
    end

    #
    # The content of the resource (this method delegates to the)
    # various private rendering methods.
    #
    # @return [String, nil]
    #   the contents of the file as a string, or nil if the resource
    #   does not contain or respond to a content renderer.
    #
    def content
      case resource_name(resource)
      when :template
        content_from_template(chef_run, resource)
      when :file
        content_from_file(chef_run, resource)
      when :cookbook_file
        content_from_cookbook_file(chef_run, resource)
      else
        nil
      end
    end

    private

    #
    # Compute the contents of a template using Chef's templating logic.
    #
    # @param [Chef::RunContext] chef_run
    #   the run context for the node
    # @param [Chef::Provider::Template] template
    #   the template resource
    #
    # @return [String]
    #
    def content_from_template(chef_run, template)
      cookbook_name = template.cookbook || template.cookbook_name
      template_location = cookbook_collection(chef_run.node)[cookbook_name].preferred_filename_on_disk_location(chef_run.node, :templates, template.source)

      if Chef::Mixin::Template.const_defined?(:TemplateContext) # Chef 11+
        template_context = Chef::Mixin::Template::TemplateContext.new([])
        template_context.update({
          :node => chef_run.node,
          :template_finder => template_finder(chef_run, cookbook_name),
        }.merge(template.variables))
        if template.respond_to?(:helper_modules) # Chef 11.4+
          template_context._extend_modules(template.helper_modules)
        end
        template_context.render_template(template_location)
      else
        template.provider.new(template, chef_run.run_context).send(:render_with_context, template_location) do |file|
          File.read(file.path)
        end
      end
    end

    #
    # Get the contents of a file resource.
    #
    # @param [Chef::RunContext] chef_run
    #   the run context for the node
    # @param [Chef::Provider::File] file
    #   the file resource
    #
    # @return [String]
    #
    def content_from_file(chef_run, file)
      file.content
    end

    #
    # Get the contents of a cookbook file using Chef.
    #
    # @param [Chef::RunContext] chef_run
    #   the run context for the node
    # @param [Chef::Provider::CookbookFile] cookbook_file
    #   the file resource
    #
    def content_from_cookbook_file(chef_run, cookbook_file)
      cookbook_name = cookbook_file.cookbook || cookbook_file.cookbook_name
      cookbook = cookbook_collection(chef_run.node)[cookbook_name]
      File.read(cookbook.preferred_filename_on_disk_location(chef_run.node, :files, cookbook_file.source))
    end

    # The cookbook collection for the current Chef run context. Handles
    # the differing cases between Chef 10 and Chef 11.
    #
    # @param [Chef::Node] node
    #   the Chef node to get the cookbook collection from
    #
    # @return [Array<Chef::Cookbook>]
    def cookbook_collection(node)
      if chef_run.respond_to?(:run_context)
        chef_run.run_context.cookbook_collection # Chef 11.8+
      elsif node.respond_to?(:run_context)
        node.run_context.cookbook_collection # Chef 11+
      else
        node.cookbook_collection # Chef 10
      end
    end

    # Return a new instance of the TemplateFinder if we are running on Chef 11.
    #
    # @param [Chef::RunContext] chef_run
    #   the run context for the noe
    # @param [String] cookbook_name
    #   the name of the cookbook
    #
    # @return [Chef::Provider::TemplateFinder, nil]
    def template_finder(chef_run, cookbook_name)
      if Chef::Provider.const_defined?(:TemplateFinder) # Chef 11+
        Chef::Provider::TemplateFinder.new(chef_run.run_context, cookbook_name, chef_run.node)
      else
        nil
      end
    end
  end
end
