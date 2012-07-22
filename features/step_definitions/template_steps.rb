Given /^a Chef cookbook with a recipe that declares a (missing )?template resource( with the template from another cookbook)?$/ do |missing,another_cookbook|
  recipe_renders_template(:missing => !! missing, :another_cookbook => !! another_cookbook)
end

Given 'the recipe has a spec example that expects the template to be rendered' do
  spec_expects_file :file, '/etc/config_file'
end

Given 'the recipe has a spec example of the rendered template' do
  spec_expects_file_with_rendered_content
end
