log 'message' do
  only_if 'test -f "/tmp/file"'
end

include_recipe 'stub_command::other_recipe'
