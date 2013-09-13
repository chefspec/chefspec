require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_template)            { it_behaves_like 'a resource matcher' }
    describe(:create_template_if_missing) { it_behaves_like 'a resource matcher', :template, :create_if_missing }
    describe(:delete_template)            { it_behaves_like 'a resource matcher' }
    describe(:touch_template)             { it_behaves_like 'a resource matcher' }
  end
end
