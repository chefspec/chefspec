# Helper method for formatting the node
nodes = search(:node, 'bar:*')
log 'nodes with an attribute' do
  message nodes.map { |node| "#{node.name}, FQDN: #{node['fqdn']}, hostname: #{node['hostname']}" }.join("\n")
end
