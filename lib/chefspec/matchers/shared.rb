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
        accepted_types << 'template' if action.to_s == 'create' and resource_type.to_s == 'file'
        chef_run.resources.any? do |resource|
          accepted_types.include? resource_type(resource) and resource.send(name_attribute) == name and
              resource_actions(resource).include? action.to_s
        end
      end
      failure_message_for_should do |actual|
        "No #{resource_type} resource named '#{name}' with action :#{action} found."
      end
      failure_message_for_should_not do |actual|
        "Found #{resource_type} resource named '#{name}' with action :#{action} that should not exist."
      end
    end
  end
end

# Render a template.
#
# @param [Chef::Resource::Template] template The template to render
# @param [Chef::Node] node The node which may be required to render the template
# @return [String] The result result of rendering the template
def render(template, node)
  # Duplicates functionality in the Chef Template provider
  context = {}; context.merge!(template.variables)
  context[:node] = node
  Erubis::Eruby.new(IO.read(template_path(template, node))).evaluate(context)
end

# Given a template, return the path on disk.
#
# @param [Chef::Resource::Template] template The template
# @return [String] The path on disk
def template_path(template, node)
  cookbook_name = template.cookbook || template.cookbook_name
  if node.respond_to?(:run_context)
    cookbook = node.run_context.cookbook_collection[cookbook_name] # Chef 11+
  else
    cookbook = node.cookbook_collection[cookbook_name] # Chef 10 and lower
  end
  cookbook.preferred_filename_on_disk_location(node, :templates, template.source)
end
