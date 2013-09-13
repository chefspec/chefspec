require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:enable_service)  { it_behaves_like 'a resource matcher' }
    describe(:disable_service) { it_behaves_like 'a resource matcher' }
    describe(:start_service)   { it_behaves_like 'a resource matcher' }
    describe(:stop_service)    { it_behaves_like 'a resource matcher' }
    describe(:restart_service) { it_behaves_like 'a resource matcher' }
    describe(:reload_service)  { it_behaves_like 'a resource matcher' }
  end
end
