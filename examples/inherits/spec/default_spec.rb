require 'chefspec'

describe 'inherits::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'allows use of the `inherits` attribute even on non-Windows' do
    expect {
      chef_run
    }.to_not raise_error
  end

  it 'matches on the default inherits attribute' do
    expect(chef_run).to create_directory('/tmp/inherit')
  end

  it 'matches on the inherits attribute' do
    expect(chef_run).to create_directory('/tmp/no_inherit').with(inherits: false)
  end
end
