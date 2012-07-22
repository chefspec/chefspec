Given /^a Chef cookbook with a recipe that declares a file resource( and sets the contents)?$/ do |sets_contents|
  if sets_contents
    recipe_with_file 'hello world'
  else
    recipe_with_file
  end
end

Given 'a Chef cookbook with a recipe that deletes a file' do
  recipe_deletes_file
end

Given 'a Chef cookbook with a recipe that creates a directory' do
  recipe_creates_directory
end

Given 'a Chef cookbook with a recipe that deletes a directory' do
  recipe_deletes_directory
end

Given 'a Chef cookbook with a recipe that creates a remote file' do
  recipe_with_remote_file
end

Given 'a Chef cookbook with a recipe that sets file ownership' do
  recipe_sets_file_ownership('file')
end

Given 'a Chef cookbook with a recipe that sets directory ownership' do
  recipe_sets_directory_ownership
end

Given 'the recipe has a spec example that expects the file to be declared' do
  spec_expects_file(:file)
end

Given /^the recipe has a spec example of the(?: cookbook)? file contents$/ do
  spec_expects_file_with_content
end

Given 'the recipe has a spec example that expects the file to be deleted' do
  spec_expects_file_to_be_deleted
end

Given 'the recipe has a spec example that expects the directory to be created' do
  spec_expects_directory
end

Given 'the recipe has a spec example that expects the directory to be deleted' do
  spec_expects_directory_to_be_deleted
end

Given 'the recipe has a spec example that expects the remote file to be created' do
  spec_expects_file(:remote_file)
end

Given 'the recipe has a spec example that expects the file to be set to be owned by a specific user' do
  spec_expects_file_with_ownership(:file)
end

Given 'the recipe has a spec example that expects the directory to be set to be owned by a specific user' do
  spec_expects_directory_with_ownership
end

Then 'the file will not have been created' do
  check_file_presence(['hello-world.txt'], false)
end

Then 'the file will not have been deleted' do
  check_file_presence(['hello-world.txt'], true)
end

Then 'the directory will not have been created' do
  check_directory_presence(['foo'], false)
end

Then 'the directory will not have been deleted' do
  check_directory_presence(['foo'], true)
end

Then 'the file will not have had its ownership changed' do
  @original_stat.should eql(owner_and_group 'hello-world.txt')
end

Then 'the directory will not have had its ownership changed' do
  @original_stat.should eql(owner_and_group 'foo')
end
