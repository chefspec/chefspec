require 'chefspec'

describe 'apt_update::periodic' do
  platform 'ubuntu'

  describe 'updates apt with default action' do
    it { is_expected.to periodic_apt_update('default_action') }
    it { is_expected.to_not periodic_apt_update('not_default_action') }
  end

  describe 'installs an apt_repository with an explicit action' do
    it { is_expected.to periodic_apt_update('explicit_action') }
  end
end
