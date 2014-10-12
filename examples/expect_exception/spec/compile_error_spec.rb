require 'chefspec'

describe 'expect_exception::compile_error' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'raises an error' do
    expect(Chef::Formatters::ErrorMapper).to_not receive(:file_load_failed)
    expect { chef_run }.to raise_error(ArgumentError)
  end
end
