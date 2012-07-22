Given 'a Chef cookbook with a recipe that declares a gem package resource' do
  recipe_installs_gem
end

Given 'a Chef cookbook with a recipe that declares a gem package resource with no action specified' do
  recipe_with_gem_no_action
end

Given 'a Chef cookbook with a recipe that declares a gem_package resource at a fixed version' do
  recipe_installs_specific_gem_version
end

Given 'a Chef cookbook with a recipe that declares a gem package resource at a fixed version with no action specified' do
  recipe_installs_specific_gem_version_with_no_action
end

Given 'a Chef cookbook with a recipe that upgrades a gem package' do
  recipe_upgrades_gem
end

Given 'a Chef cookbook with a recipe that removes a gem package' do
  recipe_removes_gem
end

Given 'a Chef cookbook with a recipe that purges a gem package' do
  recipe_purges_gem
end

Given 'the recipe has a spec example that expects the gem package to be installed' do
  spec_expects_gem_action(:install)
end

Given 'the recipe has a spec example that expects the gem package to be upgraded' do
  spec_expects_gem_action(:upgrade)
end

Given 'the recipe has a spec example that expects the gem package to be removed' do
  spec_expects_gem_action(:remove)
end

Given 'the recipe has a spec example that expects the gem package to be purged' do
  spec_expects_gem_action(:purge)
end

Given 'the recipe has a spec example that expects the gem package to be installed at that version' do
  spec_expects_gem_at_specific_version
end

Then 'the gem package will not have been installed' do
  # gem package installation would fail
end

Then 'the gem package will not have been upgraded' do
  # gem package upgrade would fail
end

Then 'the gem package will not have been removed' do
  # gem package removal would fail
end

Then 'the gem package will not have been purged' do
  # gem package purge would fail
end
