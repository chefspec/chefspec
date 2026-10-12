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

# A template and a file resource for the same path, as produced by a recipe
# that either renders or removes a config file depending on an attribute.
template '/tmp/template_or_delete' do
  source 'template.erb'
end

file '/tmp/template_or_delete' do
  action :delete
end
