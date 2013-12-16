roles = search(:role, '*:*')
roles = roles.map(&:to_s).sort.join(', ')

log 'roles' do
  message roles
end
