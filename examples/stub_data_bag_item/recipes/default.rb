template '/tmp/specific_stub' do
  variables(
    users: data_bag_item(:users, 'svargo')
  )
end
