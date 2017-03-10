powershell_script 'default_action'

powershell_script 'explicit_action' do
  action :run
end

powershell_script 'with_attributes' do
  flags '--flags'
end
