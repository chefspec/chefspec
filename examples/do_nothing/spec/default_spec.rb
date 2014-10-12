require 'chefspec'

describe 'do_nothing::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'includes the `other` recipe' do
    execute = chef_run.execute('install')
    expect(execute).to do_nothing
  end

  it 'does not include the `not` recipe' do
    execute = chef_run.execute('not_install')
    expect(execute).to_not do_nothing
  end
end
