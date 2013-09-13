require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_file)            { it_behaves_like 'a resource matcher' }
    describe(:create_file_if_missing) { it_behaves_like 'a resource matcher', :file, :create_if_missing }
    describe(:delete_file)            { it_behaves_like 'a resource matcher' }
    describe(:touch_file)             { it_behaves_like 'a resource matcher' }
  end
end
