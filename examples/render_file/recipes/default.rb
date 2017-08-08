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

template '/tmp/whitespace_template' do
  source 'whitespace_template.erb'
end
