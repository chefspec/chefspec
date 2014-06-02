require 'chef/resource/freebsd_package'

class Chef
  class Resource
    class FreebsdPackage < Chef::Resource::Package
      #
      # Chef decided it was a good idea to just shellout inside of a resource.
      # Not only is that a horrible fucking idea, but I got flak when I asked
      # to change it. So we are just going to monkey patch the fucking thing so
      # it does not shell out.
      #
      # @return [false]
      #
      def supports_pkgng?
        false
      end
    end
  end
end
