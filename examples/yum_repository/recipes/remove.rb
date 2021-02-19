# :remove is the legacy action from yum cookbook < 3.0
# :delete should be used instead, but both are valid
# so we'll support both here (for now)

yum_repository 'explicit_remove_action' do
  action :remove
end
