require 'chefspec'

describe 'compile_time::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'matches without .at_compile_time' do
    expect(chef_run).to install_package('compile_time')
  end

  it 'matches with .at_compile_time' do
    expect(chef_run).to install_package('compile_time').at_compile_time
  end

  it 'does not match when the resource is not at compile time' do
    expect(chef_run).to_not install_package('converge_time').at_compile_time
  end

  it 'matches without .at_converge_time' do
    expect(chef_run).to install_package('converge_time')
  end

  it 'matches with .at_converge_time' do
    expect(chef_run).to install_package('converge_time').at_converge_time
  end

  it 'does not match when the resource is not at converge time' do
    expect(chef_run).to_not install_package('compile_time').at_converge_time
  end
end
