Given 'a Chef cookbook with a recipe that declares a yum_package resource' do
  recipe_installs_package
end

Given 'a Chef cookbook with a recipe that declares a yum_package resource with no action specified' do
  recipe_installs_package_with_no_action
end

Given 'a Chef cookbook with a recipe that declares a yum_package resource at a fixed version' do
  recipe_installs_specific_package_version
end

Given 'a Chef cookbook with a recipe that declares a yum_package resource at a fixed version with no action specified' do
  recipe_installs_specific_package_version_with_no_action
end

Given 'a Chef cookbook that uses yum_package to upgrade a package 'do 
  recipe_upgrades_package
end

Given 'a Chef cookbook that uses yum_package to remove a package' do
  recipe_removes_package
end

Given 'a Chef cookbook that uses yum_package to purge a package' do
  recipe_purges_package
end

