require 'chefspec'

describe 'core' do
  platform 'ubuntu'

  it { is_expected.to write_log('Hello') }
end
