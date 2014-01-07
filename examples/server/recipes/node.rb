nodes = search(:node, '*:*')
nodes = nodes.map(&:to_s).sort.join(', ')

log 'nodes' do
  message nodes
end


examplenodes = []
search(:node, 'fqdn:*.example.com').each do |n|
  examplenodes << n['fqdn']
end

log 'examplenodes' do
  message examplenodes.join(', ')
end
