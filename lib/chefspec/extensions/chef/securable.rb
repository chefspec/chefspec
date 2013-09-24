require 'chef/mixin/securable'

class Chef
  module Mixin
    module Securable
      # In Chef, this module is only included if the RUBY_PLATFORM is
      # Windows-like. In ChefSpec, we want to include this, regardless of the
      # platform, becuase this module holds the `inherits` attribute, which is
      # critical in testing Windows resources.
      include WindowsSecurableAttributes

      def self.included(including_class)
        including_class.extend(WindowsMacros)
        including_class.rights_attribute(:rights)
        including_class.rights_attribute(:deny_rights)
      end
    end
  end
end
