require 'chefspec'

describe 'windows_service::configure_startup' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'configures startup for a windows_service with an explicit action' do
    expect(chef_run).to configure_startup_windows_service('explicit_action')
    expect(chef_run).to_not configure_startup_windows_service('not_explicit_action')
  end

  it 'configures startup for a windows_service with attributes' do
    expect(chef_run).to configure_startup_windows_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not configure_startup_windows_service('with_attributes').with(pattern: 'bacon')
  end

  it 'configures startup for a windows_service when specifying the identity attribute' do
    expect(chef_run).to configure_startup_windows_service('identity_attribute')
  end
end
