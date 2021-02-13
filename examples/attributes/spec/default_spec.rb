require 'chefspec'

describe 'attributes::default' do
  platform 'ubuntu'

  override_attributes['attributes']['message'] = 'The new message is here'
  automatic_attributes['ipaddress'] = '500.500.500.500'

  describe 'uses the default node attribute' do
    it { is_expected.to write_log('The new message is here') }
    it { is_expected.to_not write_log('This is the default message') }
  end

  describe 'uses the overridden ohai attribute' do
    it { is_expected.to write_log('500.500.500.500') }
    it { is_expected.to_not write_log('127.0.0.1') }
  end
end
