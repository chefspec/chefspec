require 'chef/cookbook_uploader'

class Chef::CookbookUploader
  #
  # Don't validate uploaded cookbooks. Validating a cookbook takes *forever*
  # to complete. It's just not worth it...
  #
  def validate_cookbooks
    # noop
  end
end
