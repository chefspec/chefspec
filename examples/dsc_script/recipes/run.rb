dsc_script 'default_action' do
  code <<-EOH
    Something
  EOH
end

dsc_script 'explicit_action' do
  code <<-EOH
    Another thing
  EOH
  action :run
end
