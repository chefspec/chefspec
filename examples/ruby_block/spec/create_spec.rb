require 'chefspec'

describe 'ruby_block::create' do
  platform 'ubuntu'

  describe 'creates a ruby_block with an explicit action' do
    it { is_expected.to create_ruby_block('explicit_action') }
  end

  describe 'creates a ruby_block when specifying the identity attribute' do
    it { is_expected.to create_ruby_block('identity_attribute') }
  end
end
