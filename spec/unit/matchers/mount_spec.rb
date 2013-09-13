require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:mount_mount)   { it_behaves_like 'a resource matcher' }
    describe(:umount_mount)  { it_behaves_like 'a resource matcher' }
    describe(:remount_mount) { it_behaves_like 'a resource matcher' }
    describe(:enable_mount)  { it_behaves_like 'a resource matcher' }
    describe(:disable_mount) { it_behaves_like 'a resource matcher' }
  end
end
