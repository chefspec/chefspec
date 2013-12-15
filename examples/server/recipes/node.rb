nodes = search(:node, '*:*')
nodes = nodes.map(&:to_s).sort.join(', ')

log 'nodes' do
  message nodes
end
