environments = search(:environment, '*:*')
environments = environments.map(&:to_s).sort.join(', ')

log 'environments' do
  message environments
end
