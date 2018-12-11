require 'chefspec'
require 'chefspec/policyfile'

describe 'policy_file::default' do
  platform 'redhat'

  it 'trivial test to show that policy files work' do
    expect(chef_run).to write_log('hello')
  end
end
