log 'test' do
  message "Hello #{node['platform']} #{node['platform_version']}"
end
