erl_call 'default_action'

erl_call 'explicit_action' do
  action :run
end

erl_call 'with_attributes' do
  code 'hello'
end

erl_call 'specifying the identity attribute' do
  code 'identity_attribute'
end
