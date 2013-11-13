module ChefSpec
  module Normalize
    #
    # Calculate the name of a resource, replacing dashes with underscores
    # and converting symbols to strings and back again.
    #
    # @param [String, Chef::Resource] thing
    #
    # @return [Symbol]
    #
    def resource_name(thing)
      name = thing.respond_to?(:resource_name) ? thing.resource_name : thing
      name.to_s.gsub('-', '_').to_sym
    end
  end
end
