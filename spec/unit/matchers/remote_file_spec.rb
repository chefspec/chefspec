require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_remote_file)            { it_behaves_like 'a resource matcher' }
    describe(:create_remote_file_if_missing) { it_behaves_like 'a resource matcher', :remote_file, :create_if_missing }
    describe(:delete_remote_file)            { it_behaves_like 'a resource matcher' }
    describe(:touch_remote_file)             { it_behaves_like 'a resource matcher' }
  end
end
