log 'message' do
  only_if 'test -f "/tmp/file"'
end
