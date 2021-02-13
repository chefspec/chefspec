require 'chefspec'

describe 'multiple_actions::sequential' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04', log_level: :fatal)
                        .converge(described_recipe)
  end

  describe 'executes both actions' do
    it { is_expected.to stop_service('foo').with(stop_command: 'bar') }
    it { is_expected.to start_service('foo').with(start_command: 'baz') }
  end

  describe 'does not match other actions' do
    it { is_expected.to_not disable_service('foo') }
  end
end
