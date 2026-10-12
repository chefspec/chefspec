require "chef/mixin/securable"

#
# Reopened to make the Windows security attributes available on every
# platform.
#
# @api private
#
class Chef
  #
  # Namespace for Chef's resource mixins.
  #
  # @api private
  #
  module Mixin
    #
    # Chef only includes the Windows security attributes when running on
    # Windows. ChefSpec includes them everywhere so that Windows resources can
    # be tested from any platform.
    #
    # @api private
    #
    module Securable
      # In Chef, this module is only included if the RUBY_PLATFORM is
      # Windows-like. In ChefSpec, we want to include this, regardless of the
      # platform, because this module holds the `inherits` attribute, which is
      # critical in testing Windows resources.
      include WindowsSecurableAttributes

      #
      # Extend the including resource with the Windows rights attributes.
      #
      # @param [Class] including_class
      #   the resource class including this mixin
      #
      # @return [void]
      #
      def self.included(including_class)
        including_class.extend(WindowsMacros)
        including_class.rights_attribute(:rights)
        including_class.rights_attribute(:deny_rights)
      end
    end
  end
end
