require 'chefspec'

describe 'multiple_run_action::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'includes the action explicitly given to the resource' do
    expect(chef_run).to create_template('/tmp/resource')
  end

  it 'includes an action specific called in #run_action' do
    expect(chef_run).to touch_template('/tmp/resource')
  end

  it 'does not include something random' do
    template = chef_run.template('/tmp/resource')
    expect(template.performed_actions).to_not include(:bacon)
  end
end
