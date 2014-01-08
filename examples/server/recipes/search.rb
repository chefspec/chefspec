# Helper method for formatting the node
def to_info(nodes)
  Array(nodes).map do |node|
    "#{node.name}, FQDN: #{node['fqdn']}, hostname: #{node['hostname']}"
  end.join("\n")
end

nodes = search(:node, 'bar:*')
log 'nodes with an attribute' do
  message to_info(nodes)
end
