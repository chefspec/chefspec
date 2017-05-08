#
# - Search for all nodes with recipe 'bar' and log
# - Search for all ndoes with attribute 'bar' set to a value
#

recipemsg = ''
search(:node, 'recipes\:server_search\:\:bar').each do |n|
  recipemsg += "#{n.name} (#{n['fqdn']}, #{n[:fqdn]}), "
end

log 'recipesearch' do
  message recipemsg
end

attributemsg = ''
search(:node, 'bar:*').each do |n|
  attributemsg += "#{n.name} (#{n['fqdn']}, #{n[:fqdn]}), "
end

log 'attributesearch' do
  message attributemsg
end
