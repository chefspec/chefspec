describe 'custom_resource_block' do
  platform 'ubuntu', '16.04'
  recipe do
    custom_resource_block 'name'
  end

  it { subject }
end
