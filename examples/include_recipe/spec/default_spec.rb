require "chefspec"

describe "include_recipe::default" do
  platform "ubuntu"

  describe "includes the `other` recipe" do
    it { is_expected.to include_recipe("include_recipe::other") }
  end

  describe "does not include the `not` recipe" do
    it { is_expected.to_not include_recipe("include_recipe::not") }
  end
end
