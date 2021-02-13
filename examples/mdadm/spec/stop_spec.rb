require 'chefspec'

describe 'mdadm::stop' do
  platform 'ubuntu'

  describe 'stops a mdadm with an explicit action' do
    it { is_expected.to stop_mdadm('explicit_action') }
    it { is_expected.to_not stop_mdadm('not_explicit_action') }
  end

  describe 'stops a mdadm with attributes' do
    it { is_expected.to stop_mdadm('with_attributes').with(chunk: 8) }
    it { is_expected.to_not stop_mdadm('with_attributes').with(chunk: 3) }
  end

  describe 'stops a mdadm when specifying the identity attribute' do
    it { is_expected.to stop_mdadm('identity_attribute') }
  end
end
