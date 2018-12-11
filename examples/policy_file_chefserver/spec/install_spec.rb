require 'chefspec'
# includes custom setup/teardown code specifically for testing this in memory
# not required when writing your own tests
require_relative './policyfile_setup'
require 'chefspec/policyfile'

describe 'policy_file_chefserver::default' do
  platform 'redhat'

  it 'trivial test to show that policy files work' do
    expect(chef_run).to write_log('hello')
  end
end
