log 'other message' do
  only_if 'test -f "/tmp/other_file"'
end
