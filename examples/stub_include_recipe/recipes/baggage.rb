data = Chef::DataBagItem.load('stuff', 'things')

file '/tmp/baggage.txt' do
  content data
end
