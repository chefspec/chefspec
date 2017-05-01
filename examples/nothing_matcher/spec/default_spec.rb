require 'chefspec'

describe 'nothing_matcher::default' do
  subject(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  context 'a resource with action :run' do
    it { is_expected.to run_ruby_block('yes') }
    it { is_expected.to_not nothing_ruby_block('yes') }
  end

  context 'a resource with action :nothing' do
    it { is_expected.to_not run_ruby_block('no') }
    it { is_expected.to nothing_ruby_block('no') }
  end

  context 'a resource with action [:run, :nothing]' do
    it { is_expected.to run_ruby_block('both') }
    it { is_expected.to_not nothing_ruby_block('both') }
  end
end
