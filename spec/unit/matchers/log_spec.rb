require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:write_log) { it_behaves_like 'a resource matcher' }
  end
end
