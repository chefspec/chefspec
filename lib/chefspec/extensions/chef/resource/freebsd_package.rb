require 'chef/resource/freebsd_package'

Chef::Resource::FreebsdPackage.prepend(Module.new do
  #
  # Chef decided it was a good idea to just shellout inside of a resource.
  # Not only is that a horrible fucking idea, but I got flak when I asked
  # to change it. So we are just going to monkey patch the fucking thing so
  # it does not shell out.
  #
  # @return [false]
  #
  def supports_pkgng?
    return super unless $CHEFSPEC_MODE
    true
  end
end)
