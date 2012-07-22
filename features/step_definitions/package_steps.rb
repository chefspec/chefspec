Given 'a Chef cookbook with a recipe that declares a package resource' do
  recipe_installs_package
end

Given 'a Chef cookbook with a recipe that declares a package resource with no action specified' do
  recipe_installs_package_with_no_action
end

Given 'a Chef cookbook with a recipe that declares a package resource at a fixed version' do
  recipe_installs_specific_package_version
end

Given 'a Chef cookbook with a recipe that declares a package resource at a fixed version with no action specified' do
  recipe_installs_specific_package_version_with_no_action
end

Given 'a Chef cookbook with a recipe that upgrades a package' do
  recipe_upgrades_package
end

Given 'a Chef cookbook with a recipe that removes a package' do
  recipe_removes_package
end

Given 'a Chef cookbook with a recipe that purges a package' do
  recipe_purges_package
end

Given 'the recipe has a spec example that expects the package to be installed' do
  spec_expects_package_action(:install)
end

Given 'the recipe has a spec example that expects the package to be upgraded' do
  spec_expects_package_action(:upgrade)
end

Given 'the recipe has a spec example that expects the package to be removed' do
  spec_expects_package_action(:remove)
end

Given 'the recipe has a spec example that expects the package to be purged' do
  spec_expects_package_action(:purge)
end

Given 'the recipe has a spec example that expects the package to be installed at that version' do
  spec_expects_package_at_specific_version
end

Then 'the package will not have been installed' do
  # package installation would fail
end

Then 'the package will not have been upgraded' do
  # package upgrade would fail
end

Then 'the package will not have been removed' do
  # package removal would fail
end

Then 'the package will not have been purged' do
  # package purge would fail
end
