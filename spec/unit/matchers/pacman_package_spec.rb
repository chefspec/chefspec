require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_pacman_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_pacman_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_pacman_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_pacman_package)    { it_behaves_like 'a resource matcher' }
  end
end
