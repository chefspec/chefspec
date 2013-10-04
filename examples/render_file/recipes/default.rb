file '/tmp/file' do
  content 'This is content!'
end

cookbook_file '/tmp/cookbook_file' do
  source 'cookbook_file'
end

template '/tmp/template' do
  source 'template.erb'
end

template '/tmp/partial' do
  source 'partial.erb'
end
