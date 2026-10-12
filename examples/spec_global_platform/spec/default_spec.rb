require 'chefspec'

# The platform can be set globally rather than per example group, which is how
# a lot of existing cookbooks configure it from spec_helper.rb.
RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '20.04'
end

describe 'spec_global_platform_greet' do
  step_into :spec_global_platform_greet

  context 'with the default greeting' do
    recipe do
      spec_global_platform_greet 'test'
    end

    it { is_expected.to write_log('Hello world') }
  end

  context 'with an explicit greeting' do
    recipe do
      spec_global_platform_greet('test') { message 'Hello there' }
    end

    it { is_expected.to write_log('Hello there') }
  end
end
