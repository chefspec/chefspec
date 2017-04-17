require 'chefspec'

describe 'custom_resource::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['custom_resource'])
                          .converge(described_recipe)
  end

  it 'uses the LWRP' do
    expect(chef_run).to run_custom_resource('resource')
  end

  it 'steps into the LWRP' do
    expect(chef_run).to install_package('package')
    expect(chef_run).to start_service('service')
    expect(chef_run).to create_template('template')
  end
end
