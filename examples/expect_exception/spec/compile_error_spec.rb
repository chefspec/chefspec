require "chefspec"

describe "expect_exception::compile_error" do
  platform "ubuntu"

  it "raises an error" do
    expect(Chef::Formatters::ErrorMapper).to_not receive(:file_load_failed)
    expect { subject }.to raise_error(ArgumentError)
  end
end
