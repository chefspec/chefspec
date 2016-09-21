require 'chefspec'

describe 'guards::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'includes resource that have guards that evalute to true' do
    expect(chef_run).to start_service('true_guard')
  end

  it 'excludes resources that have guards evaluated to false' do
    expect(chef_run).to_not start_service('false_guard')
  end

  it 'excludes resource that have action :nothing' do
    expect(chef_run).to_not start_service('action_nothing_guard')
  end
end
