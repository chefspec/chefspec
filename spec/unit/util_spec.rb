require 'spec_helper'
require 'chefspec/util'

describe ChefSpec::Util do
  let(:config_file_with_whitespace) do
    "
\t
    blue

  green \t
    4
  \r\n
"
  end

  it 'remove_config_file_whitespace removes config file whitespace' do
    expect(
      ChefSpec::Util.remove_config_file_whitespace(config_file_with_whitespace)
    ).to eq("    blue\n\n  green\n    4")
  end
end
