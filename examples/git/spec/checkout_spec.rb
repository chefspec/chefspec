require 'chefspec'

describe 'git::checkout' do
  platform 'ubuntu'

  describe 'checkouts a git with an explicit action' do
    it { is_expected.to checkout_git('/tmp/explicit_action') }
    it { is_expected.to_not checkout_git('/tmp/not_explicit_action') }
  end

  describe 'checkouts a git with attributes' do
    it { is_expected.to checkout_git('/tmp/with_attributes').with(repository: 'ssh://git.path') }
    it { is_expected.to_not checkout_git('/tmp/with_attributes').with(repository: 'ssh://git.other_path') }
  end

  describe 'checkouts a git when specifying the identity attribute' do
    it { is_expected.to checkout_git('/tmp/identity_attribute') }
  end
end
