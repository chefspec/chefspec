accounts = data_bag('accounts').map do |account|
  data_bag_item('accounts', account).to_s
end.sort.join(', ')

log 'accounts' do
  message accounts
end
