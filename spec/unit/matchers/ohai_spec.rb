require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:reload_ohai) { it_behaves_like 'a resource matcher' }
  end
end
