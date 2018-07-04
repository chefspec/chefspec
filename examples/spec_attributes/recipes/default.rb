package 'myapp' do
  version node['myapp']['version']
end

log node['myapp'].sort.map {|k,v| "#{k}=#{v}"}.join(' ')
