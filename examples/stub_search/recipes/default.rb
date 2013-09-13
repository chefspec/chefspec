template '/tmp/specific_stub' do
  variables(
    nodes: search(:node, 'name:example.com')
  )
end
