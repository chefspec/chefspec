require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_registry_key)            { it_behaves_like 'a resource matcher' }
    describe(:create_registry_key_if_missing) { it_behaves_like 'a resource matcher', :registry_key, :create_if_missing }
    describe(:delete_registry_key)            { it_behaves_like 'a resource matcher' }
    describe(:delete_key_registry_key)        { it_behaves_like 'a resource matcher', :registry_key, :delete_key }
  end
end
