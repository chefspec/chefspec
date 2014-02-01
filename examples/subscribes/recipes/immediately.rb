template '/tmp/notifying_resource'

service 'receiving_resource' do
  subscribes :create, 'template[/tmp/notifying_resource]', :immediately
end
