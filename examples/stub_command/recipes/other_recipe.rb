log 'other message' do
  only_if { ::File.exist?('"/tmp/other_file"') }
end
