clients = search(:client, '*:*')
clients = clients.map(&:to_s).sort.join(', ')

log 'clients' do
  message clients
end
