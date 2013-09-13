require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:deploy_deploy)       { it_behaves_like 'a resource matcher' }
    describe(:force_deploy_deploy) { it_behaves_like 'a resource matcher', :deploy, :force_deploy }
    describe(:rollback_deploy)     { it_behaves_like 'a resource matcher' }
  end
end
