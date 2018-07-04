describe 'custom_resource_block' do
  platform 'ubuntu', '16.04'
  step_into :custom_resource_block
  recipe do
    custom_resource_block 'name'
  end

  it { is_expected.to run_custom_resource_block('name') }
  it { is_expected.to write_log('hello world') }
end
