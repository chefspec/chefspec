require 'chefspec'

describe 'cookbook_gems::default' do
  platform 'ubuntu'

  describe 'converges a cookbook whose gem metadata carries options' do
    it { expect { chef_run }.to_not raise_error }
    it { is_expected.to write_log('cookbook_gems') }
  end
end
