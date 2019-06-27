require 'chefspec'

describe 'batch::run' do
  platform 'windows'

  describe 'runs a batch with the default action' do
    it { is_expected.to run_batch('default_action') }
    it { is_expected.to_not run_batch('not_default_action') }
  end

  describe 'runs a batch with an explicit action' do
    it { is_expected.to run_batch('explicit_action') }
  end

  describe 'runs a batch with attributes' do
    it { is_expected.to run_batch('with_attributes').with(flags: '-f') }
    it { is_expected.to_not run_batch('with_attributes').with(flags: '-x') }
  end
end
