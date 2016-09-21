require 'chefspec'

describe 'do_nothing::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'includes the `other` recipe' do
    execute = chef_run.execute('install')
    expect(execute).to do_nothing
  end

  it 'does not include the `not` recipe' do
    execute = chef_run.execute('not_install')
    expect(execute).to_not do_nothing
  end
end
