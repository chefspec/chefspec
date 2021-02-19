require 'chefspec'

describe 'log::write' do
  platform 'ubuntu'

  describe 'writes a log with the default action' do
    it { is_expected.to write_log('default_action') }
    it { is_expected.to_not write_log('not_default_action') }
  end

  describe 'writes a log with an explicit action' do
    it { is_expected.to write_log('explicit_action') }
  end

  describe 'writes a log with attributes' do
    it { is_expected.to write_log('with_attributes').with(level: :debug) }
    it { is_expected.to_not write_log('with_attributes').with(level: :info) }
  end

  describe 'writes a log when specifying the identity attribute' do
    skip if Chef::VERSION == '13.7.16' # this is broken in 13.7.16
    it { is_expected.to write_log('identity_attribute') }
  end
end
