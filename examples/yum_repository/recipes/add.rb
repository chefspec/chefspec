# :add is the legacy action from yum cookbook < 3.0
# :create should be used instead, but both are valid
# so we'll support both here (for now)

yum_repository 'explicit_add_action' do
  baseurl 'some_url'
  action :add
end
