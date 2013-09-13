require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_cookbook_file)            { it_behaves_like 'a resource matcher' }
    describe(:create_cookbook_file_if_missing) { it_behaves_like 'a resource matcher', :cookbook_file, :create_if_missing }
    describe(:delete_cookbook_file)            { it_behaves_like 'a resource matcher' }
    describe(:touch_cookbook_file)             { it_behaves_like 'a resource matcher' }
  end
end
