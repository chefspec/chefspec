require 'chefspec'

describe 'custom_resource::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04', step_into: ['custom_resource'])
                        .converge(described_recipe)
  end

  describe 'uses the custom resource' do
    it { is_expected.to run_custom_resource('resource') }
  end

  describe 'steps into the custom resource' do
    it { is_expected.to install_package('package') }
    it { is_expected.to start_service('service') }
    it { is_expected.to create_template('template') }
  end
end
