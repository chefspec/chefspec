require 'chef/cookbook_uploader'

Chef::CookbookUploader.prepend(Module.new do |variable|
  #
  # Don't validate uploaded cookbooks. Validating a cookbook takes *forever*
  # to complete. It's just not worth it...
  #
  def validate_cookbooks
    return super unless $CHEFSPEC_MODE
    # noop
  end
end)
