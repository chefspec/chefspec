log 'message' do
  only_if { ::File.exist?('"/tmp/file"') }
end

include_recipe 'stub_command::other_recipe'
