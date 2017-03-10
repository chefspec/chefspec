require 'chefspec'

describe 'batch::run' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'runs a batch with the default action' do
    expect(chef_run).to run_batch('default_action')
    expect(chef_run).to_not run_batch('not_default_action')
  end

  it 'runs a batch with an explicit action' do
    expect(chef_run).to run_batch('explicit_action')
  end

  it 'runs a batch with attributes' do
    expect(chef_run).to run_batch('with_attributes').with(flags: '-f')
    expect(chef_run).to_not run_batch('with_attributes').with(flags: '-x')
  end
end
