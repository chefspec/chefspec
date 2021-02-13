require "chefspec"

describe "apt_repository::add" do
  platform "ubuntu"

  describe "adds a apt_repository with default action" do
    it { is_expected.to add_apt_repository("default_action") }
    it { is_expected.to_not add_apt_repository("not_default_action") }
  end

  describe "installs a apt_repository with an explicit action" do
    it { is_expected.to add_apt_repository("explicit_action") }
  end
end
