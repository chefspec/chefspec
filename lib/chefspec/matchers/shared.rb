begin
  require 'chef/mixin/template'
  require 'chef/provider/template_finder'
rescue LoadError
end

# Given a resource return the unqualified type it is
#
# @param [String] resource A Chef Resource
# @return [String] The resource type
def resource_type(resource)
  resource.resource_name.to_s
end

# Given a resource return an array of action strings
#
# @param [String] resource A Chef Resource
# @return [Array] An array of actions as Strings
def resource_actions(resource)
  resource.action.kind_of?(Array) ? resource.action.map{ |action| action.to_s } : [ resource.action.to_s ]
end

# Define simple RSpec matchers for the product of resource types and actions
#
# @param [Array] actions The valid actions - for example [:create, :delete]
# @param [Array] resource_types The resource types
# @param [Symbol] name_attribute The name attribute of the resource types
def define_resource_matchers(actions, resource_types, name_attribute)
  actions.product(resource_types).flatten.each_slice(2) do |action, resource_type|
    RSpec::Matchers.define "#{action}_#{resource_type}".to_sym do |name|
      match do |chef_run|
        accepted_types = [resource_type.to_s]
        accepted_types += ['template', 'cookbook_file']  if action.to_s == 'create' and resource_type.to_s == 'file'
        chef_run.resources.any? do |resource|
          if (accepted_types.include? resource_type(resource) and
              name === resource.send(name_attribute) and
              resource_actions(resource).include? action.to_s and
              expected_attributes?(resource))
            @resource_name = resource.send(name_attribute)
            true
          end
        end
      end
      chain :with do |attributes|
        @attributes = attributes
      end
      failure_message_for_should do |actual|
        "No #{resource_type} resource matching name '#{name}' with action :#{action} found."
      end
      failure_message_for_should_not do |actual|
        "Found #{resource_type} resource named '#{@resource_name}' matching name: '#{name}' with action :#{action} that should not exist."
      end
      
      def expected_attributes?(resource)
        @attributes.nil? or @attributes.all?{|attribute,expected| expected === resource.send(attribute) }
      end
    end
  end
end

# Compute the contents of a template using Chef's templating logic.
#
# @param [Chef::RunContext] chef_run
#   the run context for the node
# @param [Chef::Provider::Template] template
#   the template resource
#
# @return [String]
def content_from_template(chef_run, template)
  cookbook_name = template.cookbook || template.cookbook_name
  template_location = cookbook_collection(chef_run.node)[cookbook_name].preferred_filename_on_disk_location(chef_run.node, :templates, template.source)

  if Chef::Mixin::Template.const_defined?(:TemplateContext) # Chef 11+
    template_context = Chef::Mixin::Template::TemplateContext.new([])
    template_context.update({
      :node => chef_run.node,
      :template_finder => template_finder(chef_run, cookbook_name),
    }.merge(template.variables))
    template_context.render_template(template_location)
  else
    template.provider.new(template, chef_run.run_context).send(:render_with_context, template_location) do |file|
      File.read(file.path)
    end
  end
end

# Get the contents of a file resource.
#
# @param [Chef::RunContext] chef_run
#   the run context for the node
# @param [Chef::Provider::File] file
#   the file resource
#
# @return [String]
def content_from_file(chef_run, file)
  file.content
end

# Get the contents of a cookbook file using Chef.
#
# @param [Chef::RunContext] chef_run
#   the run context for the node
# @param [Chef::Provider::CookbookFile] cookbook_file
#   the file resource
def content_from_cookbook_file(chef_run, cookbook_file)
  cookbook_name = cookbook_file.cookbook || cookbook_file.cookbook_name
  cookbook = chef_run.run_context.cookbook_collection[cookbook_name]
  File.read(cookbook.preferred_filename_on_disk_location(chef_run.node, :files, cookbook_file.source, cookbook_file.path))
end

# The cookbook collection for the current Chef run context. Handles
# the differing cases between Chef 10 and Chef 11.
#
# @param [Chef::Node] node
#   the Chef node to get the cookbook collection from
#
# @return [Array<Chef::Cookbook>]
def cookbook_collection(node)
  if node.respond_to?(:run_context)
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
