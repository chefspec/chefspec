require "chef/cookbook_loader"

Chef::CookbookLoader.prepend(Module.new do
  def all_directories_in_repo_paths
    return super unless $CHEFSPEC_MODE
    if Chef::Config[:chefspec_cookbook_root]
      # Hax.
      [Chef::Config[:chefspec_cookbook_root]]
    else
      super
    end
  end
end)
