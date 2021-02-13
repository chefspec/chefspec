require "chefspec"

describe "apt_update::update" do
  platform "ubuntu"

  describe "updates apt repo" do
    it { is_expected.to update_apt_update("update_repo") }
  end
end
