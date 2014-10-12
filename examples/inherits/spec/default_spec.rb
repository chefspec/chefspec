require 'chefspec'

describe 'inherits::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'allows use of the `inherits` attribute even on non-Windows' do
    expect {
      chef_run
    }.to_not raise_error
  end

  it 'matches on the default inherits attribute' do
    expect(chef_run).to create_directory('/tmp/inherit')
    expect(chef_run).to_not create_directory('/tmp/not_inherit')
  end

  it 'matches on the inherits attribute' do
    expect(chef_run).to create_directory('/tmp/no_inherit').with(inherits: false)
    expect(chef_run).to_not create_directory('/tmp/no_inherit').with(inherits: true)
  end
end
