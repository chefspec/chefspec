require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_remote_directory)            { it_behaves_like 'a resource matcher' }
    describe(:create_remote_directory_if_missing) { it_behaves_like 'a resource matcher', :remote_directory, :create_if_missing }
    describe(:delete_remote_directory)            { it_behaves_like 'a resource matcher' }
  end
end
