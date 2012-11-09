Given 'a Chef cookbook with a recipe that declares a chef gem package resource' do
  recipe_installs_chef_gem
end

Given 'a Chef cookbook with a recipe that declares a chef gem package resource with no action specified' do
  recipe_with_chef_gem_no_action
end

Given 'a Chef cookbook with a recipe that declares a chef gem package resource at a fixed version' do
  recipe_installs_specific_chef_gem_version
end

Given 'a Chef cookbook with a recipe that declares a chef gem package resource at a fixed version with no action specified' do
  recipe_installs_specific_chef_gem_version_with_no_action
end

Given 'a Chef cookbook with a recipe that upgrades a chef gem package' do
  recipe_upgrades_chef_gem
end

Given 'a Chef cookbook with a recipe that removes a chef gem package' do
  recipe_removes_chef_gem
end

Given 'a Chef cookbook with a recipe that purges a chef gem package' do
  recipe_purges_chef_gem
end

Given 'the recipe has a spec example that expects the chef gem package to be installed' do
  spec_expects_chef_gem_action(:install)
end

Given 'the recipe has a spec example that expects the chef gem package to be upgraded' do
  spec_expects_chef_gem_action(:upgrade)
end

Given 'the recipe has a spec example that expects the chef gem package to be removed' do
  spec_expects_chef_gem_action(:remove)
end

Given 'the recipe has a spec example that expects the chef gem package to be purged' do
  spec_expects_chef_gem_action(:purge)
end

Given 'the recipe has a spec example that expects the chef gem package to be installed at that version' do
  spec_expects_chef_gem_at_specific_version
end

Then 'the chef gem package will not have been installed' do
  # chef gem package installation would fail
end

Then 'the chef gem package will not have been upgraded' do
  # chef gem package upgrade would fail
end

Then 'the chef gem package will not have been removed' do
  # chef gem package removal would fail
end

Then 'the chef gem package will not have been purged' do
  # chef gem package purge would fail
end
