powershell_script 'default_action'

powershell_script 'explicit_action' do
  action :run
end

powershell_script 'with_attributes' do
  flags '--flags'
end

powershell_script 'specifying the identity attribute' do
  command 'identity_attribute'
end
