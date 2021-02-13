require 'chefspec'

describe 'expect_exception::no_error' do
  platform 'ubuntu'

  it 'does not raise an error' do
    expect(Chef::Formatters::ErrorMapper).to_not receive(:file_load_failed)
    expect { subject }.to_not raise_error
  end
end
